module BoardHelper
  def days_since(date)
    date.business_days_until(Time.zone.today)
  end

  def days_since_in_words(date)
    pluralize(days_since(date), 'day')
  end

  def afternoon?
    Time.zone.now.hour >= 14 # after 2pm
  end

  def categories
    {
      'PRIORITY' => 'Tasks that should be completed ASAP',
      'BUMPED' => 'Tasks that have been been interrupted',
      'BLOCKED' => 'Tasks that are waiting on blockers',
      'WASTED' => 'Tasks that are no longer worth completing'
    }
  end

  def goal_list(board)
    content_tag :ul do
      board.goals.collect { |goal| concat(content_tag(:li, goal.name)) }
    end
  end

  def task_notes_list(task)
    content_tag :ul do
      task.task_notes.collect do |task_note|
        concat(content_tag(:li, task_note.content))
      end
    end
  end

  def category_label(category)
    case category.to_sym
    when :PRIORITY, :ACTIVE, :COMPLETED
      'success'
    when :BUMPED, :BLOCKED
      'warning'
    when :WASTED
      'danger'
    end
  end

  def standup_button(board)
    if board.standup_url?
      glyph_link_to(
        board.standup_url,
        glyphicon: 'facetime-video',
        style: 'color: white; float: right; margin-right: 10px;',
        span_data: { toggle: 'tooltip', placement: 'left' },
        title: 'Join Standup'
      )
    end
  end

  def board_owner_buttons(board)
    if board.editable_by?(current_user)
      content_tag :div, class: 'float-right' do
        render 'boards/show/board_owner_buttons', board: board
      end
    end
  end

  def leave_board_button(board)
    return if board.owned_by?(current_user) || !current_user.member_of?(board)

    confirm_message = 'Are you sure you wish to remove yourself' \
                      ' from this board?'
    glyph_link_to(
      board_membership_path(current_user.membership_for(board)),
      method: :delete,
      data: { confirm: confirm_message },
      glyphicon: 'log-out',
      title: 'Leave Board'
    )
  end

  def glyph_link_to(url, options)
    link_to(url, method: options[:method] || :get, data: options[:link_data]) do
      content_tag(
        :span,
        nil,
        class: "glyphicon glyphicon-#{options[:glyphicon]} no-text-decoration",
        style: options[:style],
        data: options[:span_data],
        title: options[:title]
      )
    end
  end

  def disable_status_button(options)
    glyph_link_to(
      user_status_path(current_user.get_status(options[:status])),
      method: :delete,
      glyphicon: options[:glyphicon],
      link_data: {
        confirm: "Are you sure you wish to cancel #{options[:status]}?"
      },
      span_data: { toggle: 'tooltip', placement: 'bottom' },
      title: "Disable #{options[:status]}"
    )
  end

  def enable_status_button(options)
    url = user_user_statuses_path(
      current_user,
      user_status: { status: options[:status] }
    )
    glyph_link_to(
      url,
      method: :post,
      glyphicon: options[:glyphicon],
      link_data: { confirm: "Are you sure you're #{options[:status]} today?" },
      span_data: { toggle: 'tooltip', placement: 'bottom' },
      style: 'opacity: 0.25;',
      title: "Enable #{options[:status]}"
    )
  end

  def status_button(options)
    if current_user.send(options[:check_method])
      disable_status_button(options)
    else
      enable_status_button(options)
    end
  end

  def status_indicator(options)
    user = options[:user]
    if user != current_user && user.send(options[:check_method])
      content_tag(
        :span,
        nil,
        class: "glyphicon glyphicon-#{options[:glyphicon]}",
        title: options[:status],
        data: { toggle: :tooltip, placement: :bottom }
      )
    end
  end

  def goal_colours
    {
      'green' => 'success',
      'blue' => 'primary',
      'light blue' => 'info',
      'orange' => 'warning',
      'red' => 'danger'
    }
  end

  def board_goal_label(goal, opts = {})
    label_class = "label label-#{goal_colours[goal.colour] || 'default'} #{opts[:class]}"
    content_tag(:span, class: label_class) do
      goal.name
    end
  end
end
