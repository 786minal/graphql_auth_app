require 'rails_helper'

module Queries
  RSpec.describe 'Quries::Post::Index', type: :request do
    describe '.resolve' do
      def send_request(id, token)
        post '/graphql', params: {
          query: <<~GQL
          query {
            post(id: #{id}){
              id
              title
              description
            }
          }
          GQL
        }, headers: {
        Authorization: "Bearer #{token}"} 

        JSON.parse(response.body)
      end  

      it 'fetch a post of current user' do 
        @post = create(:post)
        token = Authentication::JwtToken::encode({ user_id: @post.user_id , exp: 24.hours.from_now.to_i })
        request = send_request(@post.id, token)
        expect(request['data']['post']).to be_present
      end
      it 'error when id is not send' do 
        @post = create(:post)
        token = Authentication::JwtToken::encode({ user_id: @post.user_id , exp: 24.hours.from_now.to_i })
        request = send_request(nil, token)
        expect(request['errors']).to be_present
      end
      it 'error when token is not send' do 
        @post = create(:post)
        expect {
          request = send_request(@post.id, nil)
        }.to raise_error(NoMethodError, "undefined method `id' for nil:NilClass")
      end  
    end
  end
end