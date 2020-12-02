namespace :close do
  desc "Export from Gateway to Close"
  task export: :environment do
    Person.all.each do |person|
      SendLeadToClose.call_later(person)
    end
  end
end
