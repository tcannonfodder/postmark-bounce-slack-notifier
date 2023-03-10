# frozen_string_literal: true

Bundler.require(:test)
SimpleCov.start do
  add_filter "/test/"
end

require 'httpx'
require "httpx/adapters/webmock"
require 'webmock/minitest'
WebMock.enable!

require 'mocha/minitest'

require_relative 'test_helper/declarative_test_patch'

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'slack_notifier'
require 'postmark_bounce_spam_notifier'
require "minitest/autorun"
