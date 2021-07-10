require 'rails_helper'

RSpec.describe Cohort, type: :model do
  subject { described_class.new(name: '42') }

  it 'formats a display name' do
    expect(subject.display_name).to eq('Cohort 42')
  end
end
