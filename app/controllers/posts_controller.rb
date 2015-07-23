class PostsController < ApplicationController

  before_action :check_auth, except: [:index]
  before_action :load_model, only:[:edit,:update,:destroy]
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
    render layout: false
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
    render layout: false
  end

  def update
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
    @post.delete
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:title,:link)
  end

end
