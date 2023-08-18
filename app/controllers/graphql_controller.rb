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
    token = request.headers['Authorization']
    return unless token.present?

    decoded_token = decode_token(token)
    return unless decoded_token.present?

    user_id = decoded_token[0]['user_id']
    User.find_by(id: user_id)
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil 
  end

  def decode_token(token)
    JWT.decode(token.split(' ').last, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
  end
end
