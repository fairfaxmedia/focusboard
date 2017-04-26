class TaskStatus < ActiveRecord::Base
  default_scope { order(created_at: :asc) }

  scope :active, -> { where(status: 'active') }

  belongs_to :task

  validates :task_id, presence: true
  validates :created_at, presence: true

  def completed?
    status == 'completed'
  end

  def time_since_set
    Time.zone.now - created_at
  end

  def end_date
    finished_at.try(:to_date) || Time.zone.now.to_date
  end

  def time_elapsed
    created_at.to_date.business_days_until(
      finished_at.try(:to_date) || Time.zone.now.to_date
    )
  end
end
