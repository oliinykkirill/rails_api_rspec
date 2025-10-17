source "https://rubygems.org"

gem "rails", "~> 8.0.0"
gem "pg", "~> 1.5"
gem "json", "~> 2.8"
gem "puma", ">= 5.0"
gem "bcrypt", "~> 3.1.20"
gem "jwt", "~> 2.8.1"
gem "jsonapi-serializer", "~> 2.2.0"
gem "kaminari", "~> 1.2.2"
gem "rack-cors", "~> 2.0.1"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development do
  gem "bullet", "~> 7.1.5", require: false
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails", "~> 6.1.3"
  gem "factory_bot_rails", "~> 6.4.3"
  gem "faker", "~> 3.3.0"
  gem "simplecov", "~> 0.22.0", require: false
  gem "rubocop", require: false
  gem "rubocop-rails-omakase", require: false
end
