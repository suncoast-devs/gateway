# frozen_string_literal: true
# Provides a service for creating an enrollment agreement with the Eversign API
class CreateCourseRegistrationInvoice
  include Callable

  def initialize(course_registration)
    @course_registration = course_registration
    @course = @course_registration.course
    @person = course_registration.person
  end

  def call
    due_date = [@course_registration.course.starts_on - 7, 1.day.from_now].max
    invoice =
      @person.invoices.create(
        due_on: due_date,
        invoice_items_attributes: [
          { description: "#{@course.name} (#{@course.session})", quantity: 1, amount: @course_registration.fee },
        ],
      )
    @course_registration.update(invoice: invoice)
    CreateInvoice.call(invoice.id)
    invoice.reload
    PersonMailer.with(course_registration: @course_registration).part_time_registration_email.deliver_later
  end
end
