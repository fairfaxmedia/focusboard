class UserPolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def destroy?
    update?
  end
end
