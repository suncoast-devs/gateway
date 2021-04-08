class Inquiry::Command::Update < Inquiry::Command
  attr_accessor :responses

  def execute
    @aggregate_root.update!(**@attributes)
  end
end
