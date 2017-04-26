class DailyNote < ActiveRecord::Base
  default_scope { order(created_at: :desc) }

  belongs_to :user

  validates :content, presence: true
  validates :user_id, presence: true, numericality: { only_integer: true }

  paginates_per 10

  def self.created_today
    where(
      created_at: DateTime.current.beginning_of_day..DateTime.current.end_of_day
    )
  end

  def self.created_yesterday
    where(created_at: 1.day.ago.beginning_of_day..1.day.ago.end_of_day)
  end

  def date
    new_record? ? Time.zone.today : created_at
  end

  def owned_by?(user)
    self.user == user
  end
end
