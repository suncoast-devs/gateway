require "test_helper"

class InquiryTest < ActiveSupport::TestCase
  test "can create an inquiry" do
    command = Inquiry::Command::Create.new("7ddc083d-9cbb-47cd-82af-821e7b09f7f4", form: "web-development-program-application", contact: {
                                                                                     name: "Astrid Rewenig",
                                                                                     email: "astridr@example.com",
                                                                                     phone: "+15555551234",
                                                                                   })

    assert_difference -> { Inquiry::Event.count }, 1 do
      assert command.execute
    end
  end

  test "can update an inquiry" do
    assert_difference -> { Inquiry::Event.count }, 2 do
      Inquiry::Command::Create.new("7ddc083d-9cbb-47cd-82af-821e7b09f7f4", form: "web-development-program-application", contact: {
                                                                             name: "Astrid Rewenig",
                                                                             email: "astridr@example.com",
                                                                             phone: "+15555551234",
                                                                           }).execute

      update = Inquiry::Command::Update.new("7ddc083d-9cbb-47cd-82af-821e7b09f7f4", responses: [
                                                                                      question: "How are you?", answer: "Fine, thank you.",
                                                                                    ])
      update.execute
      assert_equal update.aggregate_root.responses.first[:question], "How are you?"
      assert_equal update.aggregate_root.contact[:name], "Astrid Rewenig"
    end
  end

  test "validates presence of form type on create" do
    command = Inquiry::Command::Create.new("7ddc083d-9cbb-47cd-82af-821e7b09f7f4", form: "")
    assert_no_difference -> { Inquiry::Event.count } do
      refute command.execute
    end
    assert_match /blank/, command.errors[:form].first
  end

  # test "create command generated created event" do
  #   @events = @create_command.execute
  #   assert_kind_of Inquiry::Event, @events.first
  # end
end
