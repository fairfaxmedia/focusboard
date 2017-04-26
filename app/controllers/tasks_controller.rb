class TasksController < ApplicationController
  include Authorization
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_board, only: [:new, :create]
  before_action :set_user, only: [:index]
  before_action :enabled_user, only: [:update, :edit, :new, :create]
  skip_after_action :verify_authorized, only: [:index, :new]

  def index
    @tasks =
      if @user
        Task.where(user_id: @user.id)
            .includes(:board, :user)
            .newest_first.page(params[:page])
      elsif @board
        @board.tasks.includes(:board).newest_first.page(params[:page])
      else
        current_user.tasks.newest_first.page(params[:page])
      end
  end

  def show
    authorize @task
    @users = [@task.user]
  end

  def new
    @task = Task.new(user_id: current_user.id, board_id: params[:board_id])
    board = @task.board
    @users = board.editable_by?(current_user) ? board.users : [current_user]
  end

  def edit
    authorize @task
    board = @task.board
    @users = board.editable_by?(current_user) ? @task.board.users : [@task.user]
  end

  def create
    @task = Task.new(task_params)
    authorize @task
    if @task.save
      @task.task_statuses << TaskStatus.create(status: task_params[:status])
      flash[:success] = 'Task was successfully created.'
      redirect_to @task.board
    else
      render :new
    end
  end

  def update
    authorize @task
    if @task.update(task_params)
      flash[:success] = 'Task was successfully updated.'
      if [edit_task_url(@task), task_url(@task)].include?(request.referer)
        redirect_to task_path(@task)
      else
        redirect_to root_path
      end
    else
      render :edit
    end
  end

  def destroy
    authorize @task
    @task.destroy
    flash[:success] = 'Task was successfully destroyed.'
    redirect_to root_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def set_board
    @board = Board.includes(:owner).find_by(id: params[:board_id]) if params[:board_id]
  end

  def set_user
    @user = User.find_by(id: params[:user_id]) if params[:user_id]
  end

  def task_params
    params.require(:task).permit(
      :title, :description, :jira, :status,
      :user_id, :completed_at, :board_id, :board_goal_id
    )
  end
end
