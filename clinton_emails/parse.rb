require 'csv'

emails = CSV.open("Emails.csv")
emails.shift

parsed_messages = []

while email = emails.shift do
  body = email[-1]

  parsed_message = []
  # Remove inline metadata
  remove_block = false
  split = body.split("\n")[8..-9]
  next unless split
  split.each_with_index do |line, i|
    # First remove classified blocks
    if line =~ /CLASSIFIED/
      remove_block = true
    end

    if remove_block
      next
    end

    if line =~ /SUBJECT TO/
      remove_block = false
      next
    end

    if line =~ /RELEASE IN|(From|Sent|Re|To|Fwd|Fw|Attachments|For|mailto|Received|CC|Cc|Subject|Date)(:|;|,)|clintonemail.com|clintonernail.com|Case No|Doc No|Generating server:/
      next
    end

    if line =~ /SOURCE|SUBJECT|Original Message|message headers:|AuditID:|CONFIDENTIAL|PART B|.docx|@state.gov/
      next
    end

    parsed_message << line
  end

  parsed_messages << parsed_message.join("\n")
end

f = File.open("parsed_clinton_emails.txt", "w")
for msg in parsed_messages
  f.write(msg)
end

f.close
