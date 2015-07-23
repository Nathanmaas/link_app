# class PostsController < ApplicationController

  before_action :check_auth, except: [:index]

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
    @post = Post.find params[:id]

    #check ownership (not DRY)
    # unless @post.owned_by? current_user
    unless @post.user.id == current_user
      flash[:danger] = "You do not own that post"
      redirect_to root_path
    end
  end

  def update
    @post = Post.find params[:id]

    #check ownership (not DRY)
    # unless @post.owned_by? current_user
    unless @post.user.id != current_user.id
      flash[:danger] = "You do not own that post"
      redirect_to root_path
    else
      #update post if we own it
      @post.update post_params
      if @post.save
        flash[:success] = "Your link has been updated."
        redirect_to root_path
      else
        flash[:danger] = @post.errors.full_messages.uniq.to_sentence
        render :edit
      end
    end
  end

  def destroy
    post = Post.find params[:id]

    #check ownership (not DRY)
    # could use
    # unless @post.owned_by? current_user
    unless @post.user.id == current_user
      flash[:danger] = "You do not own that post"
    end
      post.delete
    end

    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:title,:link)
  end

end
