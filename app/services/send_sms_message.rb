class SendSMSMessage
  include Callable

  attr :lead_id, :contact_id, :phone_number, :message

  def initialize(lead_id, contact_id, phone_number, message)
    @lead_id = lead_id
    @contact_id = contact_id
    @phone_number = phone_number
    @message = message
  end

  def call
    CloseAPI.post("activity/sms", {
      status: "outbox",
      local_phone: "+17272357925",
      remote_phone: phone_number,
      text: message,
      contact_id: contact_id,
      lead_id: lead_id,
    })
  end
end
