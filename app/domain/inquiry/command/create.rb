class Inquiry::Command::Create < Inquiry::Command
  attr_accessor :form, :contact

  def execute
    @aggregate_root.create!(**@attributes)
  end
end
