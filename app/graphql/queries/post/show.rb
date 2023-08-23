module Queries
  module Post
    class Show < Queries::BaseQuery
      description 'Find post against current user'

      argument :id, ID, required: true  

      type Types::PostType, null: false

      def resolve(id:)
        current_user = @context[:current_user]
        ::Post.find_by(id: id, user_id: current_user.id) 
      rescue ActiveRecord::RecordNotFound => _e
      GraphQL::ExecutionError.new('Post does not exist.')
      rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
        " #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end