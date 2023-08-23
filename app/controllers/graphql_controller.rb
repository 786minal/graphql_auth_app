class GraphqlController < ApplicationController
  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: authenticated_user
    }
    result = GraphqlAuthAppSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end

  def authenticated_user
    auth_header = request.headers['Authorization']
    return unless auth_header.present?

    token = auth_header.split(' ')[1]
    decoded_token = Authentication::JwtToken::decode(token)
    return unless decoded_token.present?

    expiration_time = decoded_token[0]['exp']
    user_id = decoded_token[0]['user_id']
    User.find_by(id: user_id)
  rescue JWT::ExpiredSignature
    raise GraphQL::ExecutionError.new('Authentication token expired')
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil 
  end
end
