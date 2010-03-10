class Admin < ActiveRecord::Base
  acts_as_authentic
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    CMAdmin::Mailer.deliver_password_reset_instructions self
  end
end
