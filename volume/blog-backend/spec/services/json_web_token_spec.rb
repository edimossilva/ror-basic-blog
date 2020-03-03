require 'spec_helper'
RSpec.describe "JsonWebToken" do
  let!(:payload_data) { 
    { name: Faker::Name.name }
  }
  
  it 'retrieve data from encode and decode process' do

    token = JsonWebToken.encode(payload_data)
    decoded_data = JsonWebToken.decode(token)
    
    expect(decoded_data[:name]).to eq(payload_data[:name])
  end
end