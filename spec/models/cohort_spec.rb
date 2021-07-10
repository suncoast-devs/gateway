# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Cohort, type: :model do
  subject(:cohort) { described_class.new(name: '42') }

  it 'formats a display name' do
    expect(cohort.display_name).to eq('Cohort 42')
  end
end
