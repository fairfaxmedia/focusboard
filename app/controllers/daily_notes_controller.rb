class DailyNotesController < ApplicationController
  include Authorization
  before_action :set_daily_note,
                only: [:show, :edit, :update, :destroy]
  before_action :set_user,
                only: [:new, :create, :index]
  before_action :set_board,
                only: [:index]
  before_action :enabled_user
  skip_after_action :verify_authorized, only: :new

  def index
    if @board
      authorize @board, :edit?
      @daily_notes = DailyNote.where(user_id: @board.users.map(&:id))
                              .includes(:user)
                              .page(params[:page])
    elsif @user
      @daily_notes = DailyNote.where(user_id: @user.id)
                              .includes(:user)
                              .page(params[:page])
      authorize @daily_notes
    else
      @daily_notes = current_user.daily_notes.page(params[:page])
    end
  end

  def show
    authorize @daily_note
    @readonly = true
  end

  def edit
    authorize @daily_note
  end

  def new
    @daily_note = DailyNote.new(user_id: params[:user_id])
  end

  def create
    @daily_note = DailyNote.new(daily_note_params)
    @daily_note.user = User.find(params[:user_id])
    authorize @daily_note
    if @daily_note.save
      flash[:success] = 'Daily note was successfully created.'
      redirect_to @daily_note
    else
      render :new
    end
  end

  def update
    authorize @daily_note
    if @daily_note.update(daily_note_params)
      flash[:success] = 'Daily note was successfully updated.'
      redirect_to @daily_note
    else
      render :edit
    end
  end

  def destroy
    authorize @daily_note
    @daily_note.destroy
    flash[:success] = 'Daily note was successfully destroyed.'
    redirect_to user_daily_notes_url(current_user)
  end

  private

  def set_daily_note
    @daily_note = DailyNote.find(params[:id])
  end

  def set_user
    @user = User.find_by(id: params[:user_id]) if params[:user_id]
  end

  def set_board
    @board = Board.find_by(id: params[:board_id]) if params[:board_id]
  end

  def daily_note_params
    params.require(:daily_note).permit(:content, :positive_outcome, :user_id)
  end
end
