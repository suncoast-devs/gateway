json.person do
  json.id @person.id
  json.name @person.full_name
end

json.communications @records, partial: "message", as: :communication
