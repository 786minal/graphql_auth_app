require 'rails_helper'

RSpec.describe 'Mutations::Auth::SignUp', type: :request do
  describe 'SignUp mutation' do
    before(:all) do
      @user = create(:user)
    end
    def perform_signup(email, password)
      post '/graphql', params: {
        query: <<~GQL
        mutation {
          signUp(email: "#{email}", password: "#{password}") {
            user {
              email
            }
            token
            errors
          }
        }
        GQL
      }
      JSON.parse(response.body)['data']['signUp']
    end

    it 'returns authentication token on successful SignUp' do
      signup_data = perform_signup(Faker::Internet.email, @user.password)
      expect(signup_data['token']).to be_present
      expect(signup_data['errors']).to be_empty
    end

    it 'returns errors with unique email' do
      signup_data = perform_signup(@user.email, @user.password)
      expect(signup_data['token']).to be_nil
      expect(signup_data['errors']).to include('Email has already been taken')
    end

    it 'returns errors with pressence email' do
      signup_data = perform_signup(nil, @user.password)
      expect(signup_data['token']).to be_nil
      expect(signup_data['errors']).to include("Email can't be blank")
    end

    it 'returns errors with invalid email format' do
      signup_data = perform_signup('invalid-email', @user.password)
      expect(signup_data['token']).to be_nil
      expect(signup_data['errors']).to include('Email is invalid')
    end

    it 'returns errors with invalid password length' do
      signup_data = perform_signup(@user.email, 'vyR')
      expect(signup_data['token']).to be_nil
      expect(signup_data['errors']).to include('Password is too short (minimum is 8 characters)')
    end

    it 'returns errors with pressence email' do
      signup_data = perform_signup(@user.email, nil)
      expect(signup_data['token']).to be_nil
      expect(signup_data['errors']).to include("Password can't be blank")
    end
  end
end
