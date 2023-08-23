module Mutations
  module Auth
    class SignUp < Mutations::BaseMutation
      argument :name,  String, required: true
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :errors, [String], null: false
      field :user, Types::UserType, null: true

      def resolve(**params)
        user = User.new(name: params[:name], email: params[:email], password: params[:password])
        if user.save
          token = Authentication::JwtToken::encode(user_id: user.id)
          { user: user, token: token, errors: [] }
        else
          { user: nil, token: nil, errors: user.errors.full_messages }
        end
      end

      private
      def user_params(params)
        params.require(:user).permit(:email, :password)
      end

    end
  end
end
