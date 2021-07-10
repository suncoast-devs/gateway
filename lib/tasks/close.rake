# frozen_string_literal: true
namespace :close do
  desc 'Export from Gateway to Close'
  task export: :environment do
    Person.all.each { |person| SendLeadToClose.call_later(person) }
  end

  task notes: :environment do
    Note.all.each { |note| SendNoteToClose.call_later(note) }
  end
end
