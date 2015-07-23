class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :current_user

  def check_auth
    unless current_user
      flash[:warning] = "You must be logged in to access that page."
      redirect_to login_path
    end
  end

  def check_no_auth
    redirect_to root_path if current_user
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def load_model
    return unless params[:id]
    model_name = params[:controller].singularize
    my_model = model_name.classify.safe_constantize
    model_inst = my_model.find params[:id]
    instance_variable_set("@#{model_name}",model_inst)
  end

  def check_ownership
    model_name = params[:controller].singularize
    model_inst = instance_variable_get("@#{model_name}")
    owner = model_inst.user
    if owner.nil? || owner.id != current_user.id
      flash[:danger] = "You cannot change that which does not belong to you."
      redirect_to root_path
    end
  end

end
