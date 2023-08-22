module Mutations
  module Auth
    class Login < Mutations::BaseMutation
      argument :name, String, required: true
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :errors, [String], null: false
      field :user, Types::UserType, null: true

      def resolve(**params)
        user =  User.find_by(email: params[:email])

        if user&.authenticate( params[:password])
          payload = { user_id: user.id , exp: 24.hours.from_now.to_i }
          token   = Authentication::JwtToken::encode(payload)
          { user: user, token: token, errors: [] }
        else
          raise GraphQL::ExecutionError, 'Invalid email or password.'
        end
      end
    end
  end
end
