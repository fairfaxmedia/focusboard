class TaskNote < ActiveRecord::Base
  default_scope { order(created_at: :asc) }
  belongs_to :task

  validates :content, presence: true
  validates :task_id, presence: true, numericality: { only_integer: true }
end
