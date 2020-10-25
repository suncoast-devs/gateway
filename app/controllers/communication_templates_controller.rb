# frozen_string_literal: true

# Provides CommunicationTemplates
class CommunicationTemplatesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_communication_template, only: [:show, :edit, :update, :destroy]

  def index
    scope = CommunicationTemplate.order(name: :asc)
    @pagy, @communication_templates = pagy(scope)
  end

  def show
    @person = params[:person] ? Person.find(params[:person]) : Person.where(email_address: current_user.email).first
  end

  def new
    @communication_template = CommunicationTemplate.new
  end

  def create
    @communication_template = CommunicationTemplate.new(communication_template_params) do |template|
      template.user = current_user
    end

    if @communication_template.save
      redirect_to @communication_template, notice: "Communication Template created."
    else
      render :new
    end
  end

  def update
    if @communication_template.update(communication_template_params)
      redirect_to @communication_template, notice: "Communication Template updated."
    else
      render :edit
    end
  end

  def destroy
    @communication_template.destroy
    redirect_to communication_templates_path, notice: "Communication Template destroyed."
  end

  private

  def find_communication_template
    @communication_template = CommunicationTemplate.find(params[:id])
  end

  def communication_template_params
    params.require(:communication_template).permit(:name, :key, :title, :body, :media, :is_system)
  end
end
