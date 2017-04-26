class CompletedTicket < ActiveRecord::Base
  belongs_to :user

  def self.this_week
    beginning_of_week = DateTime.current.beginning_of_week
    end_of_week = DateTime.current.end_of_week
    where(created_at: beginning_of_week..end_of_week)
  end
end
