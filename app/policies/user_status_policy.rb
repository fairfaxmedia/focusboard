class UserStatusPolicy < ApplicationPolicy
  def create?
    record.user == user || user.admin?
  end

  def destroy?
    create?
  end
end
