module Mutations
  module Auth
    class Login < Mutations::BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :errors, [String], null: false
      field :user, Types::UserType, null: true

      def resolve(**params)
        user = User.find_for_database_authentication(email: params[:email])

        if user && user.valid_password?(params[:password])
          token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
          { user: user, token: token, errors: [] }
        else
          raise GraphQL::ExecutionError, 'Invalid email or password.'
        end
      end
    end
  end
end
