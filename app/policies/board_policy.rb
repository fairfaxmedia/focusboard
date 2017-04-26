class BoardPolicy < ApplicationPolicy
  def show?
    user.member_of?(record) || user.admin?
  end

  def edit?
    record.owned_by?(user) || user.admin?
  end

  def update?
    edit?
  end

  def destroy?
    user.admin?
  end

  def create?
    user.enabled?
  end
end
