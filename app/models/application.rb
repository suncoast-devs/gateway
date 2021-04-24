class Application < ApplicationRecord
  enum state: [:submitted, :accepted, :rejected]
end
