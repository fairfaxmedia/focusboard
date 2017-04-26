json.array!(@daily_notes) do |daily_note|
  json.extract! daily_note, :id, :content, :user_id
  json.url daily_note_url(daily_note, format: :json)
end
