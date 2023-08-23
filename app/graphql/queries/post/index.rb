module Queries
  module Post
    class Index < Queries::BaseQuery
      description 'Find all posts against current user'

      type [Types::PostType], null: false

      def resolve
       current_user = @context[:current_user]
       current_user.posts
      end
    end
  end
end
