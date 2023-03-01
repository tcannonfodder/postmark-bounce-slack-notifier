# Postmark Bounce Webhook Slack Notifier

A production-ready Slack notifier for spam notifications from Postmark (or Postmark-like) Bounce webhooks.

# Setup

## Getting your Slack webhook URL

You'll need the webhook URL to send the notifications to, so lets grab that now. 💪

* [If you're in the Kirasoft organization, here's the Slack app](https://api.slack.com/apps/A04RUE88082/incoming-webhooks?)
* If you're outside the organization, you'll need to create an internal Slack app and setup Incoming Webhooks, [see the Slack docs for more info](https://api.slack.com/messaging/webhooks)

## Installation & Setup

```sh
bundle install
cp .env.example .env
```

After that, you'll need to replace the `SLACK_WEBHOOK_URL` in `.env` with your own webhook URL

