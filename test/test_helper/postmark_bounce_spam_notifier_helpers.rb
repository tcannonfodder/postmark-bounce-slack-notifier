module PostmarkBounceSpamNotifierHelpers
  def dummy_spam_notification_payload
    return <<~JSON
      {"RecordType":"Bounce","Type":"SpamNotification","TypeCode":512,"Name":"Spam notification","Tag":"","MessageStream":"outbound","Description":"The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.","Email":"zaphod@example.com","From":"notifications@honeybadger.io","BouncedAt":"2023-02-27T21:41:30Z"}
    JSON
  end

  def dummy_hard_bounce_payload
    return <<~JSON
      {"RecordType":"Bounce","MessageStream":"outbound","Type":"HardBounce","TypeCode":1,"Name":"Hard bounce","Tag":"Test","Description":"The server was unable to deliver your message (ex: unknown user, mailbox not found).","Email":"arthur@example.com","From":"notifications@honeybadger.io","BouncedAt":"2019-11-05T16:33:54.9070259Z"}
    JSON
  end

  def dummy_spam_complaint_payload
    return <<~JSON
      {"RecordType":"SpamComplaint","MessageStream":"outbound","ID":42,"Type":"SpamComplaint","TypeCode":512,"Name":"Spam complaint","Tag":"Test","MessageID":"00000000-0000-0000-0000-000000000000","Metadata":{"a_key":"a_value","b_key":"b_value"},"ServerID":1234,"Description":"","Details":"Test spam complaint details","Email":"john@example.com","From":"sender@example.com","BouncedAt":"2019-11-05T16:33:54.9070259Z","DumpAvailable":true,"Inactive":true,"CanActivate":false,"Subject":"Test subject","Content":"<Abuse report dump>"}
    JSON
  end
end