# frozen_string_literal: true

# Provides Notes, for commenting on application
class NotesController < ApplicationController
  before_action :authenticate!
  before_action :find_person
  before_action :find_note, only: %i[update destroy]

  def create
    @note = @person.notes.create(note_params) { |note| note.user = current_user }

    SendNoteToClose.call_later @note
    publish_event :create_note, @note

    redirect_back fallback_location: @person, notice: 'Note created.'
  end

  def update
    @note.update note_params
    redirect_back fallback_location: @person
  end

  def destroy
    @note.destroy
    redirect_back fallback_location: @person, notice: 'Note destroyed.'
  end

  private

  def find_note
    @note = @person.notes.find(params[:id])
  end

  def find_person
    @person = Person.find(params[:person_id])
  end

  def note_params
    params.require(:note).permit(:message, :note_type)
  end
end
