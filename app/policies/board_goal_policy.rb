class BoardGoalPolicy < ApplicationPolicy
  def create?
    record.board.owned_by?(user) || user.admin?
  end

  def destroy?
    create?
  end

  def update?
    create?
  end
end
