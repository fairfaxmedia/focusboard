class Task < ActiveRecord::Base
  scope :completed, -> { where(status: 'completed') }
  scope :incomplete, -> { where.not(status: 'completed') }
  scope :created_before, ->(time) { where('created_at <= ?', time) }
  scope :created_after, ->(time) { where('created_at >= ?', time) }
  scope :completed_before, ->(time) { where('completed_at <= ?', time) }
  scope :completed_after, ->(time) { where('completed_at >= ?', time) }
  scope :not_owned_by, ->(user) { where.not(user: user) }
  scope :owned_by, ->(user) { where(user: user) }
  scope :newest_first, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }

  STATUSES = %w(active completed priority bumped blocked wasted).freeze
  STATUS_COLLECTION = [
    %w(Active active),
    %w(Completed completed),
    %w(Bumped bumped),
    %w(Priority priority),
    %w(Wasted wasted),
    %w(Blocked blocked)
  ].freeze

  belongs_to :user
  belongs_to :board
  belongs_to :board_goal
  has_many :task_notes, dependent: :destroy
  has_many :task_statuses, -> { order('created_at ASC') }, dependent: :destroy

  validates_associated :task_notes
  validates :title, presence: true, length: { maximum: 100 }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :user_id, presence: true, numericality: { only_integer: true }
  validates :board_id, presence: true, numericality: { only_integer: true }

  before_validation :handle_completion, if: :status_changed?
  after_save :update_status_history, if: :status_changed?

  paginates_per 10

  def self.created_this_week
    created_after(
      Time.zone.now.beginning_of_week
    ).created_before(
      Time.zone.now.end_of_week
    )
  end

  def self.completed_this_week
    completed_after(
      Time.zone.now.beginning_of_week
    ).completed_before(
      Time.zone.now.end_of_week
    )
  end

  def self.active_today
    where(
      "status = 'active' OR (status = 'completed' AND completed_at >= ?)",
      Date.current.beginning_of_day
    )
  end

  def owned_by?(user)
    self.user == user
  end

  def current_status_created_at
    return created_at unless task_statuses.any?
    last_status = task_statuses.last
    if last_status.completed?
      last_status.created_at
    else
      task_statuses.active.last.created_at
    end
  end

  def time_in_current_status
    if status == 'completed'
      total_time_in_status('active')
    else
      total_time_in_status(status)
    end
  end

  def total_time_in_status(status)
    task_statuses.where(status: status).map(&:time_elapsed).reduce(:+)
  end

  def completed?
    status == 'completed' && completed_at
  end

  def active?
    status == 'active'
  end

  def tooltip
    tooltip_items = []
    tooltip_items << description if description.present?
    tooltip_items << "(#{jira})" if jira.present?
    tooltip_items.join(' ')
  end

  private

  def handle_completion
    if status == 'completed' && completed_at.nil?
      self.completed_at = Time.zone.now
    elsif status != 'completed' && completed_at.present?
      self.completed_at = nil
    end
  end

  def update_status_history(timestamp = Time.zone.now)
    task_statuses.last.update(finished_at: timestamp) if task_statuses.any?
    task_statuses << TaskStatus.create(status: status, created_at: timestamp)
  end
end
