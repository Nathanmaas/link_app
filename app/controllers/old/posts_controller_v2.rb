class PostsController < ApplicationController

  before_action :check_auth, except: [:index]
  before_action :check_ownership, only: [:edit,:update,:destroy]

  def index
    @posts = Post.all
    respond_to do |format|
      format.html
      format.json {render json: @posts}
      format.xml {render xml: @posts}
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.create post_params
    if @post.persisted?
      flash[:success] = "Your link has been posted."
      redirect_to root_path
    else
      flash[:danger] = @post.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def edit
    #duplicate query in check_ownership
    @post = Post.find params[:id]
  end

  def update
    #duplicate query in check_ownership
    @post = Post.find params[:id]
    @post.update post_params
    if @post.save
      flash[:success] = "Your link has been updated."
      redirect_to root_path
    else
      flash[:danger] = @post.errors.full_messages.uniq.to_sentence
      render :edit
    end

  end

  def destroy
    #duplicate query in check_ownership
    post = Post.find params[:id]
    post.delete
    redirect_to root_path
  end

  private

  #could be moved to appliation controller
  #used for all controllers
  def check_ownership
    return unless params[:id]
    #duplicate query in actions
    post = Post.find params[:id]
    owner = post.user
    if owner.nil? || owner.id != current_user.id
      flash[:danger] = "You cannot change that which does not belong to you."
      redirect_to root_path
    end
  end


  def post_params
    params.require(:post).permit(:title,:link)
  end

end
