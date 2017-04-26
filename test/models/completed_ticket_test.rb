require 'test_helper'

class CompletedTicketTest < ActiveSupport::TestCase
  def setup
    @completed_ticket = completed_tickets(:one)
  end

  test 'should be valid' do
    assert @completed_ticket.valid?
  end

  test 'should not return tickets created outside this week' do
    assert_no_difference('CompletedTicket.this_week.count') do
      @last_week_ticket = CompletedTicket.new(created_at: 1.week.ago)
    end
  end

  test 'this_week should only return tickets created this week' do
    CompletedTicket.this_week.find_each do |completed_ticket|
      assert completed_ticket.created_at >= Time.zone.now.beginning_of_week
      assert completed_ticket.created_at <= Time.zone.now.end_of_week
    end
  end
end
