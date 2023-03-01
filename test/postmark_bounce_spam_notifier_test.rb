require "test_helper"
require_relative 'test_helper/postmark_bounce_spam_notifier_helpers'
require_relative 'test_helper/slack_notifier_helpers'


class PostmarkBounceSpamNotifierTest < Minitest::Test
  include PostmarkBounceSpamNotifierHelpers
  include SlackNotifierHelpers
  test "build_message: builds a Block Kit payload from the given Postmark SpamNotification payload" do
    details_text = [
      "*From*: notifications@honeybadger.io",
      "*Bounce Type*: `SpamNotification` (`512`)",
      "*Description*: The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content."
    ].join("\n")

    expected = {
      blocks: [
        {
          type: "header",
          text: {
            type: "plain_text",
            text: "ℹ️ Spam notification from Postmark Bounces",
            emoji: true
          }
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: "*Email*: zaphod@example.com"
          }
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: "*Bounced At*: <!date^1677534090^{date_num} {time_secs}|2023-02-27T21:41:30Z> (`2023-02-27T21:41:30Z`)"
          }
        },
        {
          type: "divider"
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: details_text
          }
        }
      ]
    }

    parsed_payload = JSON.parse(dummy_spam_notification_payload)

    assert_equal expected, PostmarkBounceSpamNotifier.build_message(postmark_payload: parsed_payload)
  end

  test "send_notification?: only returns true for SpamNotification" do
    assert_equal true, PostmarkBounceSpamNotifier.send_notification?(postmark_payload: JSON.parse(dummy_spam_notification_payload))

    assert_equal false, PostmarkBounceSpamNotifier.send_notification?(postmark_payload: JSON.parse(dummy_spam_complaint_payload))
    assert_equal false, PostmarkBounceSpamNotifier.send_notification?(postmark_payload: JSON.parse(dummy_hard_bounce_payload))

    parsed_payload = JSON.parse(dummy_spam_notification_payload)

    parsed_payload["Type"] = "SPaMNotification"
    assert_equal true, PostmarkBounceSpamNotifier.send_notification?(postmark_payload: JSON.parse(dummy_spam_notification_payload))

    parsed_payload["Type"] = "spamnotification"
    assert_equal true, PostmarkBounceSpamNotifier.send_notification?(postmark_payload: JSON.parse(dummy_spam_notification_payload))

    parsed_payload["Type"] = "Spamnotification"
    assert_equal true, PostmarkBounceSpamNotifier.send_notification?(postmark_payload: JSON.parse(dummy_spam_notification_payload))

    [
      "Transient",
      "Unsubscribe",
      "Subscribe",
      "AutoResponder",
      "AddressChange",
      "DnsError",
      "OpenRelayTest",
      "Unknown",
      "SoftBounce/Undeliverable",
      "VirusNotification",
      "ChallengeVerification",
      "BadEmailAddress",
      "ManuallyDeactivated",
      "Unconfirmed",
      "Blocked",
      "SMTPApiError",
      "InboundError",
      "DMARCPolicy",
      "TemplateRenderingFailed",
    ].each do |other_type|
      parsed_payload["Type"] = other_type

      assert_equal false, PostmarkBounceSpamNotifier.send_notification?(postmark_payload: parsed_payload)
    end
  end

  test "process: calls post_message on SlackNotifier when given a SpamNotification from Postmark (raw JSON)" do
    SlackNotifier.any_instance.expects(:post_message).with(dummy_successful_payload).once

    webhook_url = "https://hooks.example.com"

    notifier = PostmarkBounceSpamNotifier.new(webhook_url: webhook_url)

    assert_equal webhook_url, notifier.slack_notifier.uri.to_s

    notifier.process(postmark_payload: dummy_spam_notification_payload)
  end

  test "process: calls post_message on SlackNotifier when given a SpamNotification from Postmark (parsed JSON)" do
    SlackNotifier.any_instance.expects(:post_message).with(dummy_successful_payload).once

    webhook_url = "https://hooks.example.com"

    notifier = PostmarkBounceSpamNotifier.new(webhook_url: webhook_url)

    assert_equal webhook_url, notifier.slack_notifier.uri.to_s

    parsed_payload = JSON.parse(dummy_spam_notification_payload)

    notifier.process(postmark_payload: parsed_payload)
  end

  test "does nothing if given a SpamComplaint" do
    SlackNotifier.any_instance.expects(:post_message).never

    webhook_url = "https://hooks.example.com"

    notifier = PostmarkBounceSpamNotifier.new(webhook_url: webhook_url)

    assert_equal webhook_url, notifier.slack_notifier.uri.to_s

    parsed_payload = JSON.parse(dummy_spam_complaint_payload)

    notifier.process(postmark_payload: parsed_payload)
  end

  test "does nothing if given a HardBounce" do
    SlackNotifier.any_instance.expects(:post_message).never

    webhook_url = "https://hooks.example.com"

    notifier = PostmarkBounceSpamNotifier.new(webhook_url: webhook_url)

    assert_equal webhook_url, notifier.slack_notifier.uri.to_s

    parsed_payload = JSON.parse(dummy_hard_bounce_payload)

    notifier.process(postmark_payload: parsed_payload)
  end
end