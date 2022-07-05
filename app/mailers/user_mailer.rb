class UserMailer < ApplicationMailer

    def new_user_mailer
        @user = params[:user]

        mail(to: @user.email, 
            subject: "Welcome to Odin Facebook!")
    end 
end
