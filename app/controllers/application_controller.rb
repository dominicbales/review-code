class ApplicationController < ActionController::API
  rescue_from NotValidLendingTreeUrl, NotValidReviewUrl, with: :render_error_response

  def render_error_response(exception)
    render json: { message: exception.message, code: exception.code }, status: exception.http_status
  end
end
