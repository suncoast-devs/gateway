# frozen_string_literal: true

# Provides a service for accepting students into the web development program.
class CreateProgramAcceptance
  include Callable

  def initialize(program_acceptance_id)
    @program_acceptance = ProgramAcceptance.find(program_acceptance_id)
    @program_enrollment = @program_acceptance.program_enrollment
    @cohort = @program_acceptance.cohort
    @person = @program_acceptance.person
  end

  def call
    # Enrollment Agreement
    CreateEnrollmentAgreement.call(@program_acceptance.id)
    @program_acceptance.reload

    unless @program_enrollment.deposit_invoice
      # Deposit Invoice
      due_date = [tuition_due_date, 1.day.from_now].max
      @invoice = @person.invoices.create(due_on: due_date,
                                         invoice_items_attributes: [
                                           {description: "Tuition Deposit", quantity: 1, amount: 1000},
                                         ])
      CreateInvoice.call(@invoice.id)
      @invoice.reload
      @program_enrollment.update(deposit_invoice: @invoice)
    else
      @invoice = @program_enrollment.deposit_invoice
    end

    @program_acceptance.update(notification_body: notification_template)
    @program_enrollment.accepted!
    SyncProgramEnrollmentToActiveCampaign.call(@program_enrollment.id)
  end

  private

  def tuition_due_date
    days_before = (@cohort.begins_on.wday + 1) % 5 + 1
    due_date = @cohort.begins_on - days_before
  end

  def notification_template
    <<~TEMPLATE
      # Congratulations and Welcome Aboard!

      We're excited to tell you that **Suncoast Developers Guild has accepted your application to Cohort #{@cohort.name}**, which begins **#{@cohort.begins_on.to_s(:long_ordinal)}**. We believe you have what it takes to face an incredible commitment and the work it requires to succeed in this course. We're so glad you've decided to join us.

      ## Enrollment

      The next step is reading and [signing the **Student Enrollment Agreement**](#{@program_acceptance.enrollment_agreement_url}). Also, attached to this email is our **Program Catalog**. Please make sure you've read the enrollment agreement _and_ catalog in full.

      A deposit of $1,000 is required to reserve your spot in class while you are securing the remainder of your tuition. You can drop or mail a check to campus or [pay the deposit online](#{@invoice.payment_url}).

      Full payment of tuition or financing completely secured is required by the **Wednesday before class begins** to qualify for enrollment in this cohort. See the Financing section below for details. When you've paid the deposit, your spot in the class is guaranteed. Please make sure to submit that as soon as possible.

      ## Financing

      The remaining tuition payment is payable to Suncoast Developers Guild in full by **#{tuition_due_date.strftime("%A")}, #{tuition_due_date.to_s(:long_ordinal)}**, before the course start date.

      For private financing, we suggest exploring options with companies like [Climb Credit](https://climbcredit.com/suncoast), [LoanWell](https://loanwell.com/code-school/suncoast), and [SkillsFund](https://skills.fund/). These lenders have built loan programs specifically for code schools like ours. Of course, you can also seek lending through your favorite local bank or credit union.

      Please mail to or drop-off checks at:

      Suncoast Developers Guild\\
      2220 Central Ave\\
      St. Petersburg, FL 33712

      ## Pre-work

      Finally, it's time to get started on the [pre-work](https://suncoast.io/handbook/prework/). These resources are designed to get you ready for your cohort. Please remember to extend any questions you may have to the academic team.

      ## Recap

      So, tl;dr:

      1. [Sign the enrollment agreement](#{@program_acceptance.enrollment_agreement_url}).
      2. [Submit payment for your deposit](#{@invoice.payment_url}) and make arrangements for the balance of the tuition.
      3. [Begin the pre-work](https://suncoast.io/handbook/prework/).
      4. We'll see you in class on **#{@cohort.begins_on.to_s(:long_ordinal)}**.

      Additionally, you can [check the status of your enrollment progress](#{student_status_url(@program_enrollment.status_locator)}) at any time.

      Welcome to the **Academy at Suncoast Developers Guild**! We are excited to be a part of your journey. _It's going to be incredible_.
    TEMPLATE
  end
end
