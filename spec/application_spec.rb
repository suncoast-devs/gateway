describe Application do
  it 'should use the test environment' do
    expect(Application.env).to eq(:test)
  end
end
