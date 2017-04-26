class UsersController < ApplicationController
  include Authorization
  before_action :set_user, only: [:show, :destroy, :update]
  before_action :admin_user, only: [:index, :destroy, :update]
  skip_after_action :verify_authorized, only: [:index, :show]

  def index
    @users = User.all
  end

  def destroy
    authorize @user
    @user.destroy
    flash[:success] = 'User successfully deleted'
    redirect_to users_url
  end

  def update
    authorize @user
    @user.toggle!(:enabled)
    redirect_to users_url
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
