# frozen_string_literal: true

# Provides Documents
class DocumentsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_person
  before_action :find_document, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token, only: [:drop]

  def show
  end

  def edit
  end

  def new
    @document = @person.documents.new
  end

  def create
    @document = @person.documents.create(document_params) { |document| document.user = current_user }

    if @document.save
      redirect_to [@person, @document], notice: 'Document uploaded.'
    else
      render :new
    end
  end

  def update
    @document.update document_params
    redirect_to [@person, @document], notice: 'Document updated.'
  end

  def destroy
    @document.destroy
    redirect_to @person, notice: 'Document destroyed.'
  end

  def drop
    file = params[:file]
    @document = @person.documents.create({ label: file.original_filename, file:, user: current_user })
    head :ok
  end

  private

  def find_person
    @person = Person.find(params[:person_id])
  end

  def find_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:label, :description, :file)
  end
end
