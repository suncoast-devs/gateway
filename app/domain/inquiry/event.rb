class Inquiry::Event < ActiveRecord::Base
  serialize :payload, JsonHashSerializer
end
