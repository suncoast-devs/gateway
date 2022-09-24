# frozen_string_literal: true

# Provides Courses
class CoursesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_course, only: %i[show edit update destroy]

  def index
    scope = Course.order(starts_on: :desc)
    @pagy, @courses = pagy(scope)
  end

  def show
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to courses_path, notice: 'Course created.'
    else
      render :new
    end
  end

  def update
    if @course.update(course_params)
      redirect_to courses_path, notice: 'Course updated.'
    else
      render :edit
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_path, notice: 'Course destroyed.'
  end

  private

  def find_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:identifier, :name, :session, :starts_on, :ends_on, :days, :time)
  end
end
