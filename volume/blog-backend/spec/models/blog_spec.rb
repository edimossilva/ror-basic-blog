require 'rails_helper'

RSpec.describe Blog, type: :model do
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_many(:posts).dependent(:destroy) }

  it { should belong_to(:user) }
end
