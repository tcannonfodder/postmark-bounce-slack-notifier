require "test_helper"
require_relative 'test_helper/slack_notifier_helpers'

class SlackNotifierTest < Minitest::Test
  include SlackNotifierHelpers

  test "initialize: accepts a HTTPS webhook_url" do
    webhook_url = "https://hooks.example.com/my-webhook"

    client = SlackNotifier.new(webhook_url: webhook_url)

    assert_kind_of URI::HTTPS, client.uri
    assert_equal webhook_url, client.uri.to_s
  end

  test "initialize: accepts a HTTP webhook_url" do
    webhook_url = "http://hooks.example.com/my-webhook"

    client = SlackNotifier.new(webhook_url: webhook_url)

    assert_kind_of URI::HTTP, client.uri
    assert_equal webhook_url, client.uri.to_s
  end

  test "initialize: accepts a generic URI (will likely fail on posting, but that needs to be determined at the HTTPX layer, since a dummy value might be provided in a test environment)" do
    webhook_url = "dummy.test.host"

    client = SlackNotifier.new(webhook_url: webhook_url)

    assert_kind_of URI::Generic, client.uri
    assert_equal webhook_url, client.uri.to_s
  end

  test "post_message: accepts a hash, which will be converted to JSON" do
    webhook_url = "http://hooks.example.com/my-webhook"
    payload = dummy_successful_payload

    stub = stub_request(:post, webhook_url).with(
      body: dummy_successful_payload.to_json,
      headers: {"Content-Type" => "application/json"}
    )

    client = SlackNotifier.new(webhook_url: webhook_url)

    response = client.post_message(payload)

    assert_equal 200, response.status
    assert_equal true, response.body.empty?

    assert_requested(stub, times: 1)
  end

  test "post_message: retries network errors up to 3 times" do
    webhook_url = "http://hooks.example.com/my-webhook"
    payload = dummy_successful_payload

    stub = stub_request(:post, webhook_url).with(
      body: dummy_successful_payload.to_json,
      headers: {"Content-Type" => "application/json"}
    ).to_timeout

    client = SlackNotifier.new(webhook_url: webhook_url)

    client.post_message(payload)
    assert_requested(stub, times: 4)
  end

  test "post_message: does not retry on 5XX errors" do
    webhook_url = "http://hooks.example.com/my-webhook"
    payload = dummy_successful_payload

    stub = stub_request(:post, webhook_url).with(
      body: dummy_successful_payload.to_json,
      headers: {"Content-Type" => "application/json"}
    ).to_return(status: 504, body: "Some Slack error")

    client = SlackNotifier.new(webhook_url: webhook_url)

    response = client.post_message(payload)

    assert_equal 504, response.status
    assert_equal "Some Slack error", response.body

    assert_requested(stub, times: 1)
  end

  test "post_message: does not retry on other exceptions" do
    webhook_url = "http://hooks.example.com/my-webhook"
    payload = dummy_successful_payload

    stub = stub_request(:post, webhook_url).with(
      body: dummy_successful_payload.to_json,
      headers: {"Content-Type" => "application/json"}
    ).to_raise(RuntimeError)

    client = SlackNotifier.new(webhook_url: webhook_url)

    response = client.post_message(payload)
    assert_kind_of HTTPX::ErrorResponse, response
    assert_kind_of RuntimeError, response.error

    assert_requested(stub, times: 1)
  end

  test "post_message: raises an ArgumentError if given a String (eg: raw JSON)" do
    webhook_url = "http://hooks.example.com/my-webhook"

    client = SlackNotifier.new(webhook_url: webhook_url)

    assert_raises ArgumentError do
      client.post_message(dummy_successful_payload.to_json)
    end
  end
end
