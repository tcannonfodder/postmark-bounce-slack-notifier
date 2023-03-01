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

## Running the demo app

To test the webhook, there is a demo Sinatra app (`app.rb`), which:

- Checks for the `SLACK_WEBHOOK_URL` ENV variable, failing to boot if it's missing
- Provides an easy-to-use interface for sending out sample payloads to your Slack webhook

To start it, run:

```sh
bundle exec rake demo
```

(which is really just a shortcut of `bundle exec ruby app.rb`)

The demo payloads should not be available at (your ports may vary, though):

* Spam Notification: [http://127.0.0.1:4567/spam-notification](http://127.0.0.1:4567/spam-notification)
* Spam Complaint: [http://127.0.0.1:4567/spam-complaint](http://127.0.0.1:4567/spam-complaint)
* Hard Bounce: [http://127.0.0.1:4567/hard-bounce](http://127.0.0.1:4567/hard-bounce)