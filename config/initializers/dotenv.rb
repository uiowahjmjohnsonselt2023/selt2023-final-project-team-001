if ["development", "test"].include? ENV["RAILS_ENV"]
  Dotenv.require_keys(
    "SMTP_USERNAME",
    "SMTP_PASSWORD",
    "GOOGLE_OAUTH_CLIENT_ID",
    "GOOGLE_OAUTH_CLIENT_SECRET"
  )
end
