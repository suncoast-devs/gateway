# frozen_string_literal: true

# Provides Notes, for commenting on application
class NotesController < ApplicationController
  before_action :authenticate!
  before_action :find_program_application
  before_action :find_note, only: %i[update destroy]

  def create
    @program_application.notes.create(note_params) do |note|
      note.user = current_user
    end
    redirect_to @program_application
  end

  def update
    @note.update_attributes(note_params)
    redirect_to @program_application
  end

  def destroy
    @note.destroy
    redirect_to @program_application
  end

  private

  def find_note
    @note = @program_application.notes.find(params[:id])
  end

  def find_program_application
    @program_application = ProgramApplication.find(params[:program_application_id])
  end

  def note_params
    params.require(:note).permit(:message)
  end
end
