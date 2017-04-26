class BoardGoal < ActiveRecord::Base
  default_scope { order(priority: :asc) }

  belongs_to :board
  has_many :tasks, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :board_id },
                   length: { minimum: 2, maximum: 100 }
  validates :board_id, presence: true
  validates :priority, numericality: { only_integer: true }
end
