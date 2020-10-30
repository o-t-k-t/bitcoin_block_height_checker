require 'slack/incoming/webhooks'

class SlackWebHook
  def post(message)
    slack = Slack::Incoming::Webhooks.new ENV['SLACK_WEBHOOK_URL']
    slack.post message
  end
end
