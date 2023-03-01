# frozen_string_literal: true

require 'slack_notifier'

class PostmarkBounceSpamNotifier
  attr_reader :slack_notifier

  NOTIFICATION_TYPES = [
    "SpamNotification"
  ].map(&:downcase).freeze

  def initialize(webhook_url:)
    @slack_notifier = SlackNotifier.new(webhook_url: webhook_url)
  end

  def process(postmark_payload:)
    unless postmark_payload.is_a?(Hash)
      postmark_payload = JSON.parse(postmark_payload)
    end

    return unless self.class.send_notification?(postmark_payload: postmark_payload)

    slack_payload = self.class.build_message(postmark_payload: postmark_payload)
    slack_notifier.post_message(slack_payload)
  end

  def self.send_notification?(postmark_payload:)
    return NOTIFICATION_TYPES.include?(postmark_payload["Type"].to_s.downcase)
  end

  def self.build_message(postmark_payload:)
    bounced_at = Time.parse(postmark_payload["BouncedAt"])

    details_text = [
      "*From*: #{postmark_payload["From"]}",
      "*Bounce Type*: `#{postmark_payload["Type"]}` (`#{postmark_payload["TypeCode"]}`)",
      "*Description*: #{postmark_payload["Description"]}"
    ].join("\n")

    return {
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
            text: "*Email*: #{postmark_payload["Email"]}"
          }
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: "*Bounced At*: <!date^#{bounced_at.to_i}^{date_num} {time_secs}|#{bounced_at.iso8601}> (`#{bounced_at.iso8601}`)"
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
  end
end