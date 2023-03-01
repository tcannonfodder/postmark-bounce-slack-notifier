require 'bundler/setup'
Bundler.require(:development)

ENV.fetch('SLACK_WEBHOOK_URL')

get '/' do
  'Hello world!'
end