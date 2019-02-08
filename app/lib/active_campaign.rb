# frozen_string_literal: true

module ActiveCampaign
  FIELD_IDS = {
    deposit_outstanding: "1",
    deposit_invoice_url: "2",
    sea_signed: "3",
    sea_sign_url: "4",
    financially_cleared: "5",
    cohort_start_date: "6",
    cohort_name: "7",
    student_status_url: "9",
    continue_application_url: "11",
  }

  CREDENTIALS = Rails.application.credentials[Rails.env.to_sym][:active_campaign]

  BASE_URL = CREDENTIALS[:url]
  API_KEY = CREDENTIALS[:key]

  def self.get(action, params = nil)
    HTTP.headers("Api-Token" => API_KEY).get("#{BASE_URL}/#{action}", params: params).parse
  end

  def self.post(action, params = nil)
    HTTP.headers("Api-Token" => API_KEY).post("#{BASE_URL}/#{action}", json: params).parse
  end

  def self.post2(action, params = nil)
    HTTP.headers("Api-Token" => API_KEY).post("#{BASE_URL}/#{action}", json: params)
  end

  def self.put(action, params = nil)
    HTTP.headers("Api-Token" => API_KEY).put("#{BASE_URL}/#{action}", json: params).parse
  end

  # curl_setopt($curl, CURLOPT_URL, "https://trackcmp.net/event");
  # curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
  # curl_setopt($curl, CURLOPT_POST, true);
  # curl_setopt($curl, CURLOPT_POSTFIELDS, array(
  # "actid" => "1000235908",
  # "key" => "344217d7bb981f5ce322850afe7e9afd6c18bbe4",
  # "event" => "YOUR_EVENT",
  # "eventdata" => "ANY_DATA",
  # "visit" => json_encode(array(
  # 		// If you have an email address, assign it here.
  # 		"email" => "",
  # 	)),
  # ));

  def self.event(event_name, email = nil, data = nil)
    HTTP.post("https://trackcmp.net/event", form: {
                                              actid: "1000235908",
                                              key: "344217d7bb981f5ce322850afe7e9afd6c18bbe4",
                                              event: event_name,
                                              eventdata: data.to_s,
                                              visit: {
                                                email: email,
                                              }.to_json,
                                            })
  end
end
