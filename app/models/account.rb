class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :surveys

  has_many :authentications, dependent: :destroy

  def self.from_omniauth(auth)
    Authentication.where(auth.slice("provider", "uid")).first.try(:account) || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    unless account = Account.find_by_email(auth["info"]["email"])
      password = Devise.friendly_token[0,20]
      account = Account.create(
        email:                  auth.info.email,
        first_name:             auth.info.first_name,
        last_name:              auth.info.last_name,
        password:               password,
        password_confirmation:  password,
      )
    end

    account.authentications.build(
      provider: auth["provider"],
      uid:  auth["uid"],
      token: auth["credentials"]["token"]
    )
    account.save
    account
  end

end
