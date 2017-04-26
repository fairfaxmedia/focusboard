if Rails.env.production?
  creds = Aws::Credentials.new(
    ENV['SES_ACCESS_KEY_ID'],
    ENV['SES_SECRET_ACCESS_KEY']
  )
  Aws::Rails.add_action_mailer_delivery_method(
    :aws_sdk,
    credentials: creds,
    region: 'us-east-1'
  )
end
