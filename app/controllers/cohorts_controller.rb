# frozen_string_literal: true

# Provides Cohorts
class CohortsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_cohort, only: %i[show edit update destroy]

  def index
    scope = Cohort.order(begins_on: :asc)
    @pagy, @cohorts = pagy(scope)
  end

  def show
  end

  def new
    @cohort = Cohort.new
  end

  def create
    @cohort = Cohort.new(cohort_params)

    if @cohort.save
      redirect_to cohorts_path, notice: 'Cohort created.'
    else
      render :new
    end
  end

  def update
    if @cohort.update(cohort_params)
      redirect_to cohorts_path, notice: 'Cohort updated.'
    else
      render :edit
    end
  end

  def destroy
    @cohort.destroy
    redirect_to cohorts_path, notice: 'Cohort destroyed.'
  end

  private

  def find_cohort
    @cohort = Cohort.find(params[:id])
  end

  def cohort_params
    params.require(:cohort).permit(:name, :begins_on, :ends_on, :note, :format, :delivery, :is_enrolling)
  end
end
