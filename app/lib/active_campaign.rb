# frozen_string_literal: true

module ActiveCampaign
  BASE_URL = Rails.application.credentials.active_campaign_url
  API_KEY = Rails.application.credentials.active_campaign_key

  def self.get(action, params = nil)
    HTTP.headers("Api-Token" => API_KEY).get("#{BASE_URL}/#{action}", params: params).parse
  end

  def self.post(action, params = nil)
    HTTP.headers("Api-Token" => API_KEY).post("#{BASE_URL}/#{action}", json: params).parse
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
