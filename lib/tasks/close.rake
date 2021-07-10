# frozen_string_literal: true
namespace :close do
  desc 'Export from Gateway to Close'
  task export: :environment do
    Person.all.each do |person|
      SendLeadToClose.call_later(person)
    end
  end

  task notes: :environment do
    Note.all.each do |note|
      SendNoteToClose.call_later(note)
    end
  end
end
