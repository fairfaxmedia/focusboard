class User < ActiveRecord::Base
  scope :not_member_of_board, ->(board) { where.not(id: board.users) }
  scope :without_user, ->(user) { where.not(id: user.id) }

  has_many :tasks, dependent: :destroy
  has_many :daily_notes, dependent: :destroy
  has_many :board_memberships, dependent: :destroy
  has_many :boards, through: :board_memberships
  has_many :owned_boards, class_name: 'Board', foreign_key: 'owner_id', dependent: :destroy
  has_many :statuses, class_name: 'UserStatus', dependent: :destroy
  has_many :completed_tickets, dependent: :destroy

  validates_associated :tasks
  validates_associated :daily_notes
  validates_associated :board_memberships
  validates :name, presence: true, length: { in: 2..50 }
  validates :email, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false }
  validates :enabled, inclusion: { in: [true, false] }
  validates :admin, inclusion: { in: [true, false] }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable

  def tasks_active_today(board)
    tasks.where('board_id = ?', board.id).active_today
  end

  def reviewed_today?
    todays_review.present?
  end

  def todays_review
    daily_notes.created_today.first
  end

  def reviewed_yesterday?
    daily_notes.created_yesterday.any?
  end

  def name_and_email
    "#{name} (#{email})"
  end

  def tasks_created_this_week(board = nil)
    return tasks.created_this_week.where(board_id: board.id) if board.present?
    tasks.created_this_week
  end

  def tasks_created_and_completed_this_week(board = nil)
    return tasks.completed.created_this_week.completed_this_week if board.nil?
    board.tasks.completed.created_this_week.completed_this_week
  end

  def tasks_completed_this_week(board = nil)
    return board.tasks.completed.completed_this_week if board.present?
    tasks.completed.completed_this_week
  end

  def total_completion_fraction
    "#{tasks.completed.length}/#{tasks.length}"
  end

  def weekly_completion_fraction
    "#{tasks_created_and_completed_this_week.length}/"\
    "#{tasks_created_this_week.length}"
  end

  def tasks_created_today(board)
    tasks.where(
      'board_id = ? AND created_at >= ?',
      board, Time.zone.now.beginning_of_day
    )
  end

  def tasks_created_and_completed_today(board)
    tasks.where(
      "board_id = ? AND created_at >= ? AND status = 'completed'",
      board, Time.zone.now.beginning_of_day
    )
  end

  def tasks_completed_today(board)
    tasks.where(
      "board_id = ? AND status = 'completed' AND completed_at >= ?",
      board, Time.zone.now.beginning_of_day
    )
  end

  def daily_completion_percentage(board)
    return 0 if tasks_active_today(board).empty?
    tasks_completed_today(board).length.to_f /
      tasks_active_today(board).length.to_f
  end

  def daily_completion_fraction(board)
    "#{tasks_completed_today(board).length}/#{tasks_active_today(board).length}"
  end

  def member_of?(board)
    boards.include?(board)
  end

  def membership_for(board)
    board_memberships.find_by(board_id: board.id)
  end

  def working_from_home_today?
    statuses.created_today.where(status: 'WFH').any?
  end

  def oncall_this_week?
    statuses.created_this_week.where(status: 'Oncall').any?
  end

  def sick?
    statuses.created_today.where(status: 'Sick').any?
  end

  def get_status(type)
    statuses.where(status: type).last
  end

  def on_leave?
    statuses.where(status: 'Leave').any?
  end

  def ticket_tally
    completed_tickets.this_week.count
  end
end
