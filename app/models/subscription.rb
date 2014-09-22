class Subscription < ActiveRecord::Base
  include TokenGenerator

  STATUSES = {
    'active'    => 1,
    'inactive'  => 2,
    'canceled'  => 3,
  }

  attr_accessor :number, :year, :month, :verification_value, :ip

  serialize :info, Hash
  monetize :subtotal_cents
  monetize :tax_cents
  monetize :total_cents
  mount_uploader :invoice_file, PrintFileUploader

  belongs_to :account
  belongs_to :plan
  has_one :billing_address, as: :addressable, class_name: 'Address', dependent: :destroy

  accepts_nested_attributes_for :billing_address
  
  before_create :inactive_others
  after_create :generate_invoice_and_send_mail

  scope :active, -> { where(status: 1) }
  scope :paid, -> { where(paid: true) }
  scope :inatec, -> { where(payment_method: 'inatec') }

  STATUSES.each do |n, v|
    define_method :"is_#{n}?" do
      status == v
    end
  end

  def calculate_prices
    self.subtotal_cents = plan.price_cents

    self.total_cents = ((subtotal_cents / 100.0) * Rails.application.secrets[:tax_percentage].to_f) + subtotal_cents
    self.tax_cents = total_cents - subtotal_cents
  end

  def self.process_recurring
    free_plan = Plan.free

    Subscription.inatec.active.where(expired_at: Date.today).find_each do |s|
      account = s.account

      new_subscription = Subscription.new(s.attributes.except("id", "token", "invoice_file", "expired_at", "created_at", "updated_at"))
      new_subscription.build_billing_address(s.billing_address.attributes.except("id", "subscription_id", "created_at", "updated_at"))

      if new_subscription.create_recurring_payment!
        new_subscription.save
      else # failed
        account.plan_id = free_plan.id
        account.save

        account.subscriptions.active.update_all(status: STATUSES['inactive'])
      end
    end
  end

  def self.total_amount
    Subscription.paid.sum(:total_cents)
  end

  def create_payment!
    response = ::INATEC_GATEWAY.authorize_with_recurring(total_cents, credit_card, purchase_options)

    process_response(response)

    self.card_brand = credit_card.brand
    self.last_4_digits = credit_card.display_number

    response.success?
  end

  def create_recurring_payment!
    response = ::INATEC_GATEWAY.charge_recurring(total_cents, transaction_id, purchase_options)

    process_response(response)

    response.success?
  end

  def cancel!
    self.status = STATUSES['canceled']
    self.save

    self.account.plan_id = Plan.free.id
    self.account.save
  end

  def self.generate_pdf(subscription_id)
    subscription = Subscription.find(subscription_id)
    return if subscription.payment_method == 'baio'

    FileUtils.mkpath("tmp/subscriptions")
    tmp_path = "tmp/subscriptions/invoice_#{subscription.id}.pdf"

    pdf_content = PdfCreator.render_invoice(subscription)
    File.open(tmp_path, 'wb'){|f| f.write pdf_content }

    subscription.invoice_file = File.open(tmp_path)
    subscription.save
    FileUtils.rm(tmp_path)

    AccountMailer.payment_success_mail(subscription.id).deliver
  end

  def check_credit_card_validation
    success = true

    unless credit_card.valid?
      success = false

      credit_card.errors.each do |k,v|
        unless v.blank?
          errors.add(k, v.first)
          errors.add(:number, 'is invalid') if k == 'brand'
        end
      end
    end

    success
  end
  
  private

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      first_name:         account.first_name,
      last_name:          account.last_name,
      month:              month,
      year:               year,
      verification_value: verification_value,
      number:             number
    )
  end

  def process_response(response)
    if response.success?
      self.info = response.params
      self.transaction_id = response.params["transid"].first if self.transaction_id.blank?
      self.expired_at = Time.now + plan.duration.to_i.month
      self.status = STATUSES['active']
      self.paid = true
    else
      errors.add :base, response.message
    end
  end

  def purchase_options
    {
      order_id:     SecureRandom.random_number(1000000000),
      ip:           ip,
      first_name:   account.first_name,
      last_name:    account.last_name,
      description:  'Presentation7 plan purchase',
      email:        account.email,
      currency:     Rails.application.secrets[:currency_code],
      address: {
        zip:        billing_address.postal_code,
        street:     billing_address.address_1,
        city:       billing_address.city,
        country:    billing_address.billing_country
      }
    }
  end

  def generate_invoice_and_send_mail
    Subscription.delay.generate_pdf(self.id)
  end

  def inactive_others
    account.subscriptions.active.update_all(status: STATUSES['inactive'])
  end
end
