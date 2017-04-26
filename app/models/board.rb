class Board < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_many :tasks, dependent: :destroy
  has_many :board_memberships, dependent: :destroy
  has_many :users, through: :board_memberships
  has_many :goals, foreign_key: 'board_id', class_name: 'BoardGoal', dependent: :destroy

  validates_associated :tasks
  validates_associated :board_memberships
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :owner_id, presence: true, numericality: { only_integer: true }

  before_validation :jira_nil_if_blank

  def membership_for(user)
    board_memberships.find_by(user_id: user.id)
  end

  def categorise_tasks_by(property)
    # Hacky fix for hash of arrays
    categorised_tasks = Hash.new { |h, k| h[k] = [] }
    tasks.oldest_first.includes(:user).each do |task|
      categorised_tasks[task.send(property)] << task
    end
    categorised_tasks
  end

  def non_members
    User.not_member_of_board(self)
  end

  def owned_by?(user)
    user == owner
  end

  def viewable_by?(user)
    user.member_of?(self) || user.admin?
  end

  def editable_by?(user)
    user.admin? || owned_by?(user)
  end

  private

  def jira_nil_if_blank
    self.jira_url = nil if jira_url.blank?
  end
end
