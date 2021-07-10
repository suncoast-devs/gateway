# frozen_string_literal: true

class ContactDispositionsController < ApplicationController
  before_action :authenticate!
  before_action :find_person

  def create
    @contact_disposition = @person.contact_dispositions.create(contact_disposition_params) do |contact_disposition|
      contact_disposition.user = current_user
    end

    redirect_back fallback_location: @person, notice: 'Contact disposition recorded.'
  end

  def destroy
    @contact_disposition = @person.contact_dispositions.find(params[:id])
    @contact_disposition.destroy
    redirect_back fallback_location: @person, notice: 'Contact disposition removed.'
  end

  private

  def find_person
    @person = Person.find(params[:person_id])
  end

  def contact_disposition_params
    params.require(:contact_disposition).permit(:code, :contacted_at)
  end
end
