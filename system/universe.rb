# frozen_string_literal: true
Dir[Application.root.join('lib/**/*.rb')].each { |file| require file }
