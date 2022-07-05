class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    def send_welcome_email 
        UserMailer.with(user: @user).new_user_mailer.deliver_now! 
    end 

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
        devise_parameter_sanitizer.permit(:account_update, keys: [:birthday, :occupation, :location, :avatar])
    end
end
