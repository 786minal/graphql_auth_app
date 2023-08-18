module Mutations
  module Auth
    class SignUp < Mutations::BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :errors, [String], null: false
      field :user, Types::UserType, null: true

      def resolve(**params)
        user = User.new(email: params[:email], password: params[:password])
        if user.save
          token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
          { user: user, token: token }
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
