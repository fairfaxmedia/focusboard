require 'test_helper'

class BoardHelperTest < ActionView::TestCase
  def setup
    @user = users(:enableduser)
  end

  test 'categories returns correct categories' do
    assert_equal categories.keys, %w(PRIORITY BUMPED BLOCKED WASTED)
  end
end
