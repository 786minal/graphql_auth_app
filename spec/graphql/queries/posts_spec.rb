require 'rails_helper'

module Queries
  RSpec.describe 'Quries::Post::Index', type: :request do
    describe '.resolve' do
      def send_request(token)
        post '/graphql', params: {
          query: <<~GQL
          query {
            posts{
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

      it 'fetch all posts' do 
        @post = create(:post)
        token = Authentication::JwtToken::encode({ user_id: @post.user_id , exp: 24.hours.from_now.to_i })
        request = send_request(token)
        expect(request['data']['posts']).to be_present
      end
      it 'authentiation error' do 
        @post = create(:post)
        expect {
            send_request(nil)
          }.to raise_error(NoMethodError, "undefined method `posts' for nil:NilClass")
      end  
    end
  end
end