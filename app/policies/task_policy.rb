class TaskPolicy < ApplicationPolicy
  def show?
    user.admin? || user.member_of?(record.board)
  end

  def edit?
    record.owned_by?(user) || user.admin? || record.board.owned_by?(user)
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def create?
    edit?
  end
end
