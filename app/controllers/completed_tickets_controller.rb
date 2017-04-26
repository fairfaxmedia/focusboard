class CompletedTicketsController < ApplicationController
  def create
    @completed_ticket = CompletedTicket.new(user: user)
    authorize @completed_ticket
    @completed_ticket.save
    redirect_to root_path
  end

  private

  def user
    @user ||= User.find(params[:user_id])
  end

  def authorize_creation
    user = User.find(params[:user_id])
    redirect_to root_path unless current_user?(user)
  end
end
