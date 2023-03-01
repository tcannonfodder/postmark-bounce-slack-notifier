# frozen_string_literal: true

require 'uri'
require 'httpx'

class SlackNotifier
  attr_reader :client, :uri

  def initialize(webhook_url:)
    @uri = URI(webhook_url)
  end

  def post_message(message)
    raise ArgumentError, "`message' is a string-like object; it needs to be a hash-like object to be encoded as JSON" if message.kind_of?(String)
    http_client.post(uri, json: message)
  end

  protected

  def http_client
    @client ||= HTTPX.plugin(:retries, retry_change_requests: true).with_headers("Content-Type" => "application/json")
  end
end