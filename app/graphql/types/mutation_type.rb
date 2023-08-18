module Types
  class MutationType < Types::BaseObject
    field :sign_up, mutation: Mutations::Auth::SignUp
    field :login, mutation: Mutations::Auth::Login
  end
end
