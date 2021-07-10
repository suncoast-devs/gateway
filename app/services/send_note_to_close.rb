# frozen_string_literal: true
class SendNoteToClose
  include Callable

  attr :note, :person

  def initialize(note)
    @note = note
    @person = note.notable if note.notable.is_a? Person
  end

  def call
    return if note.close_note.present?
    return unless person.present? && person.close_lead.present?

    params = { note: note.message, lead_id: person.close_lead, date_created: note.created_at.iso8601 }

    if note.user.close_user.present?
      params[:user_id] = note.user.close_user
    else
      params[:note] = note.message + "\n\nOriginal note from #{note.user.name}."
    end

    response = Close::API.post('activity/note', params)
    note.update(close_note: response['id'])
  end
end
