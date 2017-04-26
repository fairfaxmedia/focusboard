class TaskNotesController < ApplicationController
  include Authorization
  before_action :set_task_note, only: [:destroy]
  before_action :enabled_user

  def create
    @task_note = TaskNote.new(task_note_params.merge(task_id: params[:task_id]))
    authorize @task_note
    if @task_note.save
      flash[:success] = 'Task note was successfully created.'
      redirect_to @task_note.task
    else
      @task = @task_note.task
      @readonly = false
      redirect_to task_path(@task)
    end
  end

  def destroy
    authorize @task_note
    task = @task_note.task
    @task_note.destroy
    respond_to do |format|
      flash[:success] = 'Task note was successfully destroyed.'
      format.html { redirect_to task_path(task) }
      format.json { head :no_content }
    end
  end

  private

  def set_task_note
    @task_note = TaskNote.find(params[:id])
  end

  def task_note_params
    params.require(:task_note).permit(:content, :task_id)
  end
end
