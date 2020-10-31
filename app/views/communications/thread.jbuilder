json.person do
  json.id @person.id
  json.name @person.full_name
end

json.communications @records do |communication|
  json.id communication.id

  json.subject communication.subject
  json.body communication.body.truncate(500)
  json.time communication.messaged_at
  json.media communication.media
  json.is_outgoing communication.outgoing?
end
