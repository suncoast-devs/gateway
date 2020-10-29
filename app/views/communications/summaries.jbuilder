json.people @records do |person|
  communication = person.last_communication

  json.id person.id
  json.person_name person.full_name
  json.subject communication.subject
  json.summary communication.body.truncate(200)
  json.time communication.messaged_at
  json.is_unread communication.is_unread

  if communication.user.present?
    json.last_sender communication.user.first_name
  else
    json.last_sender person.given_name
  end
end
