class PostsController < ApplicationController

    before_action :require_signed_in!

    def new
        @post = Post.new
        render :new
    end

    def show
        @posts = Post.all
        render :show
    end

    def edit
        @author = current_user if current_user.id = self.author_id
        if @author
            render :edit
        else
            flash[:errors] = ['You aint the author of the posts!']
            redirect_to posts_url
        end
    end

    def create
        @post = Post.new(post_params)
        @post.sub_id = params[:sub_id]
        @post.author_id = params[:author_id]
        unless @post.save
            flash[:errors] = @post.errors.full_messages
        end
        redirect_to users_url(@post.author)
    end

    def update
        @post = current_user.posts.find_by(id: params[:id])
        if @post && @post.update(post_params)
            redirect_to posts_url
        else
            flash[:errors] = @post.errors.full_messages
            redirect_to posts_url
        end
    end

    def destroy
        @post = current_user.posts.find_by(id: params[:id])
        if @post && @post.delete
            redirect_to users_url
        end
    end

    private
    def post_params
        params.require(:post).permit(:title, :url, :content)
    end

end