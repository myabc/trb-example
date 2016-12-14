module Api
  class ApiController < ActionController::Base
    include Pundit

    before_action :doorkeeper_authorize!
    before_action :authenticate_user!

    unless Rails.env.development? || Rails.env.test?
      rescue_from StandardError do |exception|
        Rails.logger.error exception.message
        Raven.capture_exception(exception)
        render json: { errors: [ApiErrors.hash_for_key_and_message(:internal_server_error, exception.message)] }, status: :internal_server_error
      end
    end

    rescue_from Pundit::NotAuthorizedError do |exception|
      Rails.logger.warn "#{exception.message}: #{exception.query} #{exception.record}"
      render json: { errors: [ApiErrors.hash_for_key(:forbidden)] }, status: :forbidden
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      Rails.logger.warn exception.message
      render json: { errors: [ApiErrors.hash_for_key(:not_found)] }, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |exception|
      Rails.logger.warn exception.message
      render json: { errors: [ApiErrors.hash_for_message(exception.message)] }, status: :unprocessable_entity
    end
    rescue_from ActiveRecord::RecordInvalid do |exception|
      Rails.logger.warn exception.message
      render json: { errors: [ApiErrors.hash_for_key_and_message(:validation_failed, exception.message)] }, status: :unprocessable_entity
    end

    rescue_from PG::NumericValueOutOfRange do |_ecxeption|
      # happens on look up of invalid obfuscated IDs
      render json: { errors: [ApiErrors.hash_for_key(:not_found)] }, status: :not_found
    end

    def unauthenticated?
      current_user.nil?
    end

    def unprivileged?
      unauthenticated? || current_user.patient?
    end

    def authenticate_user!
      if doorkeeper_token
        Thread.current[:current_user] = User.find(doorkeeper_token.resource_owner_id)
      end

      return if current_user

      render json: { errors: ['User is not authenticated!'] }, status: :unauthorized
    end

    def current_user
      Thread.current[:current_user]
    end

    def errors_json(messages)
      { errors: [*messages] }
    end
  end
end
