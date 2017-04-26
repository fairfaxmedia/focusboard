class BoardGoalsController < ApplicationController
  before_action :set_board_goal, only: [:destroy, :update]
  before_action :set_board, only: :create

  def create
    @board_goal = @board.goals.new(board_goal_params)
    authorize @board_goal
    if @board_goal.save
      flash[:success] = 'Board goal was successfully created.'
    else
      @readonly = false
    end
    redirect_to edit_board_path(@board_goal.board)
  end

  def destroy
    authorize @board_goal
    board = @board_goal.board
    @board_goal.destroy
    flash[:success] = 'Board goal was successfully destroyed.'
    redirect_to edit_board_path(board)
  end

  def update
    authorize @board_goal
    @board_goal.update(board_goal_params)
    redirect_to edit_board_path(@board_goal.board)
  end

  private

  def set_board_goal
    @board_goal = BoardGoal.find(params[:id])
  end

  def set_board
    @board = Board.find(params[:board_id])
  end

  def board_goal_params
    params.require(:board_goal).permit(:name, :priority, :colour, :board_id)
  end
end
