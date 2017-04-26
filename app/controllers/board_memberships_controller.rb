class BoardMembershipsController < ApplicationController
  before_action :set_board_membership, only: :destroy
  before_action :ensure_not_owner, only: :destroy
  before_action :set_board, only: :create
  skip_after_action :verify_authorized, only: :new

  def create
    @board_membership = @board.board_memberships.new(board_membership_params)
    authorize @board_membership
    if @board_membership.save
      flash[:success] = 'User was successfully added to board.'
    else
      flash[:danger] = 'Unable to add user to board.'
    end
    redirect_to edit_board_path(@board_membership.board)
  end

  def destroy
    authorize @board_membership
    board = @board_membership.board
    @board_membership.destroy
    flash[:success] = 'User was successfully removed from board.'
    if board.owned_by?(current_user) || current_user.admin?
      redirect_to edit_board_path(board)
    else
      session.delete(:board_id)
      redirect_to boards_path
    end
  end

  private

  def set_board_membership
    @board_membership = BoardMembership.find(params[:id])
  end

  def set_board
    @board = Board.find(params[:board_id])
  end

  def board_membership_params
    params.require(:board_membership).permit(:board_id, :user_id)
  end

  def ensure_not_owner
    board = @board_membership.board
    user = @board_membership.user
    redirect_to edit_board_path(board) if board.owned_by?(user)
  end
end
