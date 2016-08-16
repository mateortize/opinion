module TokenGenerator
  extend ActiveSupport::Concern
  
  included do
    before_create :set_token
  end

  def set_token
    self.token = SecureRandom.urlsafe_base64
  end
end