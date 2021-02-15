class SubsController < ApplicationController

    before_action :require_signed_in!

    def edit
        @mod = current_user if current_user.id == self.moderator_id
        if @mod
            render :edit 
        else
            flash[:errors] = ['You aint the moderator']
            redirect_to subs_url
        end
    end

    def show
        @sub = Sub.find(params[:id])
        render :show
    end

    def index
        @subs = Sub.all
        render :index
    end

    def new
        @sub = Sub.new
        render :new
    end

    def create
        @sub = Sub.new(sub_params)
        @sub.moderator_id = @current_user.id
        unless @sub.save
            flash.now[:errors] = @sub.errors.full_messages
            render :new
        end
    end

    private

    def sub_params
        params.require(:sub).permit(:title, :description)
    end


end