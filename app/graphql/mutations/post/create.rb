module Mutations
  module Post
    class Create < Mutations::BaseMutation
      argument :title, String, required: true
      argument :description, String, required: true

      field :title, String, null: true
      field :description, String, null: true
      field :errors, [String], null: false
      field :post, Types::PostType, null: true

      def resolve(**params)
        binding.pry
        post = context[:current_user].posts.new(title: params[:title], description: params[:description])
        if post.save
          {post: post, errors: []}
        else
          {post: nil, errors: post.errors.full_messages}
        end
      end
    end
  end
end
