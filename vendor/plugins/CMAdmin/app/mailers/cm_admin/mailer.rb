module CMAdmin
  class Mailer < ActionMailer::Base
    def password_reset_instructions(admin)
      subject       "Password Reset Instructions"
      from          'TODO@carnesmedia.com'
      recipients    admin.email
      sent_on       Time.current
      body          :edit_password_reset_url => edit_cm_admin_password_reset_url(admin.perishable_token)
    end
  end
end