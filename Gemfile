source 'https://rubygems.org'

gem 'httpx'

group :test, :development do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem 'rack', '~> 2.2.4'
  gem 'sinatra'
  gem 'puma'
end

group :test do
  gem 'minitest'
  gem 'simplecov'
end