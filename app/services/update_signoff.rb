# frozen_string_literal: true

# Provides a service for updating academic and administrative signoff
class UpdateSignoff
  include Callable

  def initialize(program_application_id, signoff_type)
    @program_application = ProgramApplication.find(program_application_id)
    @signoff_type = signoff_type
    @nutshell = Nutshell.client
  end

  def call
    update_crm_status
  end

  private

  def update_crm_status
    lead = @nutshell.get_lead(@program_application.crm_identifier)
    @nutshell.edit_lead(@program_application.crm_identifier, lead['rev'], customFields: { crm_field => crm_value })
  end

  def crm_field
    @signoff_type.match?(/^academic/) ? 'Academic Sign-off ' : 'Administrative Sign-off'
  end

  def crm_value
    @program_application.send[@signoff_type] ? 'Accept' : 'Reject'
  end
end
