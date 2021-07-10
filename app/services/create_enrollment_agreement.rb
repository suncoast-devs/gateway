# frozen_string_literal: true

# Provides a service for creating an enrollment agreement with the eSignatures.io API
class CreateEnrollmentAgreement
  include Callable
  
  BASE_TUITION = 14_900

  def initialize(program_acceptance)
    @program_acceptance = program_acceptance
    @cohort = @program_acceptance.cohort
    @person = @program_acceptance.person
  end

  def call
    return unless Rails.env.production?
    response = HTTP.basic_auth(
      user: Rails.application.credentials.esignatures_api_key, pass: ''
    ).post('https://esignatures.io/api/contracts', json: document_data).parse
    @program_acceptance.update(enrollment_agreement_url: response.dig('data', 'contract', 
'signers').first['sign_page_url'])
  end

  private

  def document_data
    {
      test: Rails.env.production? ? 'no' : 'yes',
      metadata: @program_acceptance.id,
      template_id: '1eac09fa-eecc-49d5-a558-f35f59eabfc7',
      signers: [{
        name: @person.full_name,
        email: @person.email_address,
        mobile: @person.phone_number&.phony_normalized,
        skip_signer_identification: 'yes',
        signing_order: '1'
      }, {
        name: 'Jason L Perry',
        email: 'jason@suncoast.io',
        company_name: 'Suncoast Developers Guild, Inc.',
        auto_sign: 'yes',
        signing_order: '2'
      }],
      signer_fields: [
        { api_key: 'name', value: @person.full_name },
        { api_key: 'telephone', value: @person.phone_number&.phony_formatted },
        { api_key: 'email', value: @person.email_address }
      ],
      placeholder_fields: [
        { api_key: 'program', value: 'Web Development' },
        { api_key: 'clock_hours', value: '396' },
        { api_key: 'start_date', value: @cohort.begins_on.strftime('%b %d, %Y') },
        { api_key: 'end_date', value: @cohort.ends_on.strftime('%b %d, %Y') },
        { api_key: 'base_tuition', value: BASE_TUITION.to_s(:delimited) },
        { api_key: 'scholarships', value: @program_acceptance.tuition_reduction.to_s(:delimited) },
        { api_key: 'total_tuition', value: (BASE_TUITION - @program_acceptance.tuition_reduction).to_s(:delimited) }
      ]
    }
  end
end
