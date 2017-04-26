class BoardsController < ApplicationController
  include Authorization
  before_action :set_board, only: [:show, :edit, :update, :destroy]
  before_action :enabled_user, only: [:new, :create]
  skip_after_action :verify_authorized, only: [:index, :new]

  def index
    current_user.admin? ? @boards = Board.all : @boards = current_user.boards
  end

  def show
    authorize @board
    @users = @board.users.without_user(current_user)
    @users.unshift(current_user) if current_user.member_of?(@board)
    @tasks = @board.categorise_tasks_by('status')
    @tasks['wasted'].select! { |task| task.time_in_current_status <= 5 }
  end

  def new
    @board = Board.new(owner_id: current_user.id)
    @users = User.all
  end

  def create
    @board = Board.new(board_params)
    authorize @board
    @board.owner = current_user
    if @board.save
      BoardMembership.new(board_id: @board.id, user_id: current_user.id).save
      redirect_to @board, notice: 'Board was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize @board
    @board_membership = BoardMembership.new
  end

  def update
    authorize @board
    if @board.update(board_params)
      redirect_to @board, notice: 'Board was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @board
    @board.destroy
    redirect_to boards_url, notice: 'Board was successfully destroyed.'
  end

  private

  def set_board
    if params[:id]
      @board = Board.includes(:users).find_by_id(params[:id])
      session[:board_id] = @board.id
    elsif session[:board_id]
      @board = Board.includes(:users).find_by_id(session[:board_id])
    end
    redirect_to boards_path unless @board
  end

  def board_params
    params.require(:board).permit(:name, :jira_url, :owner_id, :standup_url)
  end
end
