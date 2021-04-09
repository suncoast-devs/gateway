class InquiryFormProjection
  def self.on(event_channel, &handler)
    Wisper.subscribe(handler, on: event_channel, with: :call)
  end

  on :inquiry_created do |event|
    inquiry_form = InquiryForm.create({
      aggregate: event.aggregate,
      form_title: event.payload[:form].titleize,
      contact_name: event.payload.dig(:contact, :name),
      contact_email: event.payload.dig(:contact, :email),
      contact_phone: event.payload.dig(:contact, :phone),
      responses: event.payload[:responses],
      is_complete: event.payload[:is_complete],
      created_at: event.created_at,
      updated_at: event.created_at,
    })
  end

  on :inquiry_updated do |event|
    inquiry_form = InquiryForm.where({ aggregate: event.aggregate }).take
    inquiry_form.update({ responses: event.payload[:responses], updated_at: event.created_at })
  end

  on :inquiry_completed do |event|
    inquiry_form = InquiryForm.where({ aggregate: event.aggregate }).take
    inquiry_form.update({ is_complete: true, updated_at: event.created_at })
  end
end
