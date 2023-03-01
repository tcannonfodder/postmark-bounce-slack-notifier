source 'https://rubygems.org'

gem 'httpx'

group :test, :development do
  gem "rake"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem 'dotenv', require: 'dotenv/load'
  gem 'rack', '~> 2.2.4'
  gem 'sinatra'
  gem 'puma'
end

group :test do
  gem "m"
  gem 'minitest'
  gem 'simplecov'
  gem 'webmock'
  gem 'mocha'
end