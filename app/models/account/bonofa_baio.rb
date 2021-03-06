module Account::BonofaBaio
  extend ActiveSupport::Concern
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def find_with_bonofa_oauth(oauth)
      account = Account.find_by_email(oauth.info.email)

      if account
        account.promotion_code = oauth.info.promotion_code
        account.baio_account_id = oauth.uid
        account.company = oauth.extra.raw_info.company
      else
        password = Devise.friendly_token[0,20]
        account = Account.new(
          baio_account_id:        oauth.uid,
          email:                  oauth.info.email,
          first_name:             oauth.info.first_name,
          last_name:              oauth.info.last_name,
          promotion_code:         oauth.info.promotion_code,
          language:               oauth.info.language,
          info:                   oauth.info,
          password:               password,
          password_confirmation:  password,
          company: oauth.extra.raw_info.company
        )
      end
      #account.remote_avatar_image_url = oauth.info.profile_image_url
      account.save

      free_plan = Package.free.plans.first
      pro_plan = Package.pro.plans.first
      expert_plan = Package.expert.plans.first
      
      if !["pro_package", "vip_package"].include?(oauth.info.baio_package)
        if account.has_active_subscription? 
          if account.active_subscription.payment_method == 'baio'
            account.active_subscription.cancel!
            account.plan_id = free_plan.id
          end
        else
          account.plan_id = free_plan.id
        end

      else
        unless account.has_active_subscription?
          account.subscriptions.create(
            plan_id:    expert_plan.id,
            payment_method: 'baio',
            expired_at: Time.now + 100.year,
            status:     1
          )
        end
        account.plan_id = expert_plan.id
      end

      account.save
      account
    end
  end
end