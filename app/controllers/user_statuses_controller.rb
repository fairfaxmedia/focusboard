class UserStatusesController < ApplicationController
  before_action :set_user_status, only: [:destroy]

  def create
    @user_status = UserStatus.new(
      user_status_params.merge(user_id: params[:user_id])
    )
    authorize @user_status

    if @user_status.save
      flash[:success] = "#{@user_status.status} successfully enabled."
    else
      flash[:danger] = 'Unable to set status.'
    end
    redirect_to root_path
  end

  def destroy
    authorize @user_status
    @user_status.destroy
    redirect_to(
      root_path,
      notice: "#{@user_status.status} successfully cancelled."
    )
  end

  private

  def set_user_status
    @user_status = UserStatus.find(params[:id])
  end

  def user_status_params
    params.require(:user_status).permit(:status, :user_id)
  end
end
