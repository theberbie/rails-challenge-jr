class Message < ApplicationRecord
  has_secure_password validations: false
  validates :body, presence: true
  validates :tos_accepted, acceptance: { message: 'MUST ACCEPT' }

  before_create :generate_token

 protected

 def generate_token
   self.token = loop do
     random_token = SecureRandom.urlsafe_base64(nil, false)
     break random_token unless Message.exists?(token: random_token)
   end
 end

end
