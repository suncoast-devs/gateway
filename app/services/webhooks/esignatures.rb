# frozen_string_literal: true
require 'open-uri'

module Webhooks
  class Esignatures
    include Callable

    def initialize(params)
      @params = params.with_indifferent_access
    end

    def call
      status = @params[:status]
      if status == 'contract-signed'
        program_acceptance = ProgramAcceptance.find(@params.dig(:data, :metadata))
        program_acceptance.person.notes.create note_type: 'other-event',
                                               message: 'Student Enrollment Agreement is complete.',
                                               data: @params
        program_acceptance.program_enrollment.update(enrollment_agreement_complete: true)
        document = program_acceptance.person.documents.new(label: 'Student Enrollment Agreement')
        document.file.attach(
          io: URI.open(@params.dig(:data, :contract_pdf_url)),
          filename: 'student-enrollment-agreement.pdf',
          content_type: 'application/pdf',
        )
        document.save
        program_acceptance.person.succeed_contact!
      else
        person = ProgramAcceptance.find(@params.dig(:data, :contract, :metadata)).person
        case status
        when 'signer-viewed-the-contract'
          person.notes.create note_type: 'other-event', message: 'Student Enrollment Agreement viewed.', data: @params
        when 'signer-declined'
          person.notes.create note_type: 'other-event',
                              message: 'Student declined to sign the Student Enrollment Agreement.',
                              data: @params
        when 'error'
          person.notes.create note_type: 'other-event',
                              message:
                                "Error signing Student Enrollment Agreement:\n`#{@params.dig(:data, :error_code)}`",
                              data: @params
        end
      end
    end
  end
end
