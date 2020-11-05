json.people @records do |person|
  communication = person.last_communication

  json.id person.id
  json.name person.full_name
  json.email person.email_address

  if communication.present?
    json.subject communication.subject
    json.summary communication.body.truncate(200)
    json.time communication.messaged_at
    json.is_unread communication.is_unread?
    json.is_outgoing communication.outgoing?

    if communication.outgoing?
      if communication.user.present?
        json.last_sender communication.user == current_user ? "You" : communication.user.first_name
      else
        json.last_sender "SDG"
      end
    else
      json.last_sender person.given_name
    end
  end
end
