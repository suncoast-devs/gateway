class SendBulkSMS
  include Callable

  attr :lead_query, :message

  def initialize(lead_query, message)
    @lead_query = lead_query
    @message = message
  end

  def call
    size = 50
    page = 0

    loop do
      response = Close::API.get("lead", query: lead_query, _skip: page * size, _limit: size)

      response["data"].each do |lead|
        contact_id = lead.dig("contacts", 0, "id")
        phone_number = lead.dig("contacts", 0, "phones", 0, "phone")
        SendSMSMessage.call_later(lead["id"], contact_id, phone_number, message)
      end

      page += 1
      break unless response["has_more"]
    end
  end
end
