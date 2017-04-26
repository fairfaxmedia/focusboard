class CompletedTicketPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
end
