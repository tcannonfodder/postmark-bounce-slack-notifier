require 'bundler/setup'
Bundler.require(:development)

get '/' do
  'Hello world!'
end