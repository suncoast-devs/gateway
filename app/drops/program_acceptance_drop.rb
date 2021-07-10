# frozen_string_literal: true
class ProgramAcceptanceDrop < Liquid::Drop
  delegate :enrollment_agreement_url, to: :@program_acceptance, allow_nil: true

  def initialize(program_acceptance)
    @program_acceptance = program_acceptance
  end
end
