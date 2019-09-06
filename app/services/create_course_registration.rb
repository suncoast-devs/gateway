
# Provides a service for creating an enrollment agreement with the Eversign API
class CreateCourseRegistration
  include Callable

  def initialize(person_id, identifier, code)
    @person = Person.find(person_id)
    @course = Course.where(identifier: identifier).where("starts_on > ?", Date.today).first
    @identifier = identifier
    @code = code
  end

  def call
    fee = @code =~ /guildies/i ? 720 : 1200
    registration = @person.course_registrations.create(course: @course, code: @code, fee: fee)
    due_date = [@course.starts_on - 7, 1.day.from_now].max
    invoice = @person.invoices.create(due_on: due_date,
                                      invoice_items_attributes: [
                                        { description: "#{@course.name} (#{@course.session})", quantity: 1, amount: registration.fee },
                                      ])
    registration.update(invoice: invoice)
    CreateInvoice.call(invoice.id)
    invoice.reload
    PersonMailer.with(course_registration: registration).part_time_registration_email.deliver_now
  end
end
