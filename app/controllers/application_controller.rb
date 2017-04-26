class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :verify_authorized, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  def current_user?(user)
    user == current_user
  end

  def user_not_authorized
    flash[:danger] = "You are not authorized to do that."
    redirect_to boards_path
  end
end
