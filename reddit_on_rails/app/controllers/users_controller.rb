class UsersController < ApplicationController

    before_action require_signed_in!, only: [:show, :index]

    def new
        @user = User.new
        render :new
    end

    def index
        @users = User.all
        render :index
    end

    def show
        @users = User.find(params[:id])
        render :show
    end

    def create
        @user = User.new(user_params)
        if @user.save
            sign_in!(@user)
            redirect_to users_url
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end
    
    private
    def user_params
        params.require(:user).permit(:username, :password)
    end

end