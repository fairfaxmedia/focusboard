class BoardMembershipPolicy < ApplicationPolicy
  def create?
    record.board.owned_by?(user) || user.admin?
  end

  def destroy?
    create? || record.user == user
  end
end
