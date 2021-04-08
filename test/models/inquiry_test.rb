require "test_helper"

class InquiryTest < ActiveSupport::TestCase
  setup do
    #     @create_command = [
    # ,
    #       {
    #         form: "web-development-program-application",
    #         contact: {
    #           name: "Astrid Rewenig",
    #           email: "astridr@example.com",
    #           phone: "+15555551234",
    #         }
    #       }
    #     ]
  end

  test "can create an inquiry" do
    command = Inquiry::Command::Create.new("7ddc083d-9cbb-47cd-82af-821e7b09f7f4", form: "web-development-program-application", contact: {
                                                                                     name: "Astrid Rewenig",
                                                                                     email: "astridr@example.com",
                                                                                     phone: "+15555551234",
                                                                                   })

    assert_difference -> { Inquiry::Event.count }, 1 do
      command.execute
    end
  end

  test "can update an inquiry" do
    assert_difference -> { Inquiry::Event.count }, 2 do
      Inquiry::Command::Create.new("7ddc083d-9cbb-47cd-82af-821e7b09f7f4", form: "web-development-program-application", contact: {
                                                                             name: "Astrid Rewenig",
                                                                             email: "astridr@example.com",
                                                                             phone: "+15555551234",
                                                                           }).execute

      Inquiry::Command::Update.new("7ddc083d-9cbb-47cd-82af-821e7b09f7f4", responses: [
                                                                             question: "How are you?", answer: "Fine, thank you.",
                                                                           ]).execute
    end
  end

  test "validates presence of form type on create" do
    command = Inquiry::Command::Create.new("7ddc083d-9cbb-47cd-82af-821e7b09f7f4", form: "")
    command.execute
    assert_match /blank/, command.errors[:form].first
  end

  # test "create command generated created event" do
  #   @events = @create_command.execute
  #   assert_kind_of Inquiry::Event, @events.first
  # end
end
