class RegistrationsController < ApplicationController
    def new
        
        if !user_signed_in? && !current_user.role == "admin"
            redirect_to '/'
            flash[:notice] = "You must be an admin to create new users!"
        end
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if @user.save
            redirect_to '/'
        end
    end
    
    private
    
        def user_params
           params.require(:user).permit(:fullname, :emai, :password, :password_confirmation) 
        end
end