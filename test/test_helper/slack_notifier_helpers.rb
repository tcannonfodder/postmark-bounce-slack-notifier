module SlackNotifierHelpers
  def dummy_successful_payload
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
            text: "*From*: notifications@honeybadger.io\n*Bounce Type*: `SpamNotification` (`512`)\n*Description*: The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content."
          }
        }
      ]
    }
  end
end