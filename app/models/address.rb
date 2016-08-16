class Address < ActiveRecord::Base
  validates_presence_of :address_1, :city, :state, :postal_code, :country, if: "addressable_type == 'Subscription'"

  belongs_to :addressable, polymorphic: true

  def country_name
    @country_name ||= Country[country].try(:name)
  end

  def billing_country
    bc = ActiveMerchant::Country::COUNTRIES.select { |x| x[:alpha2] == country }
    bc.blank? ? '' : bc.first[:alpha3]
  end

  # helper method
  def address_line1
    if !address_1.blank? and !address_2.blank?
      "#{address_1}, #{address_2}"
    else
      "#{address_1} #{address_2}".strip
    end
  end

  def address_line2
    if city.blank?
      "#{state} #{postal_code}".strip
    else
      "#{city}, #{state} #{postal_code}".strip
    end
  end

  def city_and_country
    if country.blank?
      city
    else
      "#{city}, #{country_name}"
    end
  end

  def incomplete?
    (address_1.blank? || postal_code.blank? || city.blank? || country.blank?)
  end
end
