class AdminController < ApplicationController
  include Authorization

  skip_after_action :verify_authorized, only: :index

  def index
    user_not_authorized unless current_user.admin?
    @users = User.all
    @tasks = Task.includes(:board, :user).all
    @daily_notes = DailyNote.includes(:user).all
    @boards = Board.includes(:owner).all
  end
end
