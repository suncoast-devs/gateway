# frozen_string_literal: true
class CohortDrop < Liquid::Drop
  
  delegate :name, :display_name, :is_enrolling, :tuition_due_date,
    :begins_on, :ends_on, :format, :note, :delivery,
    to: :@cohort, allow_nil: true

  def initialize(cohort)
    @cohort = cohort
  end
end
