require 'trailblazer/endpoint/rails'

require_dependency 'api_errors'
require_dependency 'api_responder'
require_dependency 'roar_api_responder'

class Api::V1::ApiController < Api::ApiController
  include Roar::Rails::ControllerAdditions
  self.responder = ::RoarApiResponder
  respond_to :json

  rescue_from Trailblazer::NotAuthorizedError do |_exception|
    render json: { errors: [ApiErrors.hash_for_key(:forbidden)] },
           status: :forbidden
  end
end
