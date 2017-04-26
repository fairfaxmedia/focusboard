module DailyNotesHelper
  def thumbs_class(daily_note)
    'glyphicon glyphicon-thumbs-' \
    "#{daily_note.positive_outcome? ? 'up green' : 'down red'}"
  end
end
