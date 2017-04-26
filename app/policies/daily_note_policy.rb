class DailyNotePolicy < ApplicationPolicy
  def show?
    boards_owned = record.user.boards.includes(:owner).select { |board| board.owned_by?(user) }
    record.owned_by?(user) || boards_owned.any? || user.admin?
  end

  def create?
    !user.reviewed_today? && record.owned_by?(user)
  end

  def edit?
    record.owned_by?(user) || user.admin?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def index?
    daily_notes = record
    boards_owned = daily_notes.select { |board| board.owned_by?(user) }
    user == daily_notes.first.try(:user) || daily_notes.empty? ||
      boards_owned.any? || user.admin?
  end
end
