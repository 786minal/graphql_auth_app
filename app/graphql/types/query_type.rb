module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # /posts
    field :posts, [Types::PostType], null: false,
      description: "All posts"

    def posts
      current_user = @context[:current_user]
      current_user.posts
    end

     # /posts/:id
    field :post, Types::PostType, null: false,
      description: "Fetch speccfic post" do
      argument :id, ID, required: true
    end

    def post(id:)
      current_user = @context[:current_user]
      Post.find_by(id: id, user_id: current_user.id) 
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Post does not exist.')
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
