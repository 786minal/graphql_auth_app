require 'rails_helper'

RSpec.describe 'Mutations::Auth::Login', type: :request do
  describe 'login mutation' do
    before(:all) do
      @user = create(:user)
    end
    def perform_login(email, password)
      post '/graphql', params: {
        query: <<~GQL
          mutation {
            login(email: "#{email}", password: "#{password}") {
              token
              errors
            }
          }
        GQL
      }

      JSON.parse(response.body)
    end

    it 'returns authentication token on successful login' do
      login_data = perform_login(@user.email, @user.password)
      expect(login_data['data']['login']['token']).to be_present
      expect(login_data['data']['login']['errors']).to be_empty
    end

    it 'returns error due to failure of nil email on login' do
      login_data = perform_login(nil, @user.password)
      expect(login_data['errors'][0]['message']).to eq('Invalid email or password.')
    end

    it 'returns error due to failure of nil password on login' do
      login_data = perform_login(@user.email, nil)
      expect(login_data['errors'][0]['message']).to eq('Invalid email or password.')
    end

    it 'returns error due to email format on login' do
      login_data = perform_login("tets.com", @user.password)
      expect(login_data['errors'][0]['message']).to eq('Invalid email or password.')
    end

    it 'returns error due to incorrect password on login' do
      login_data = perform_login(@user.email, '1234')
      expect(login_data['errors'][0]['message']).to eq('Invalid email or password.')
    end
  end
end
