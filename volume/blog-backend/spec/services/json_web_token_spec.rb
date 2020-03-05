# frozen_string_literal: true

require 'spec_helper'
RSpec.describe 'JsonWebToken' do
  let!(:payload_data) do
    { name: Faker::Name.name }
  end

  it 'retrieve data from encode and decode process' do
    token = JsonWebToken.encode(payload_data)
    decoded_data = JsonWebToken.decode(token)

    expect(decoded_data[:name]).to eq(payload_data[:name])
  end
end
