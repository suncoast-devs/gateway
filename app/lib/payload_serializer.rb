class PayloadSerializer
  def self.dump(payload)
    ActiveJob::Arguments.serialize(Array(payload))
  end

  def self.load(payload)
    payload = JSON.load(payload) if payload.is_a? String
    ActiveJob::Arguments.deserialize(Array(payload)).first
  end
end
