class TaskNotePolicy < ApplicationPolicy
  def create?
    task = record.task
    task.owned_by?(user) || task.board.owned_by?(user) || user.admin?
  end

  def destroy?
    create?
  end
end
