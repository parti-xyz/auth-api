require 'rails_helper.rb'

describe 'user_exists' do
  it 'creates user' do
    user = user_exists()
    expect(user).to be_an(User)
  end
end