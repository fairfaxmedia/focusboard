class UserStatus < ActiveRecord::Base
  default_scope { order(created_at: :asc) }

  belongs_to :user

  validates :status, presence: true

  def self.created_this_week
    where(
      created_at: Date.current.beginning_of_week..Date.current.end_of_week
    )
  end

  def self.created_today
    where(
      created_at: Date.current.beginning_of_day..Date.current.end_of_day
    )
  end
end
