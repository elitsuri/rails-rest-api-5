module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_user!
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid,  with: :unprocessable
      rescue_from ActionController::ParameterMissing, with: :bad_request

      private

      def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last
        raise StandardError, 'Missing token' if token.nil?
        payload = AuthService.decode_token(token)
        @current_user = User.find(payload[:user_id])
      rescue JWT::DecodeError, StandardError => e
        render json: { error: e.message }, status: :unauthorized
      end

      def current_user = @current_user
      def not_found(e) = render(json: { error: e.message }, status: :not_found)
      def unprocessable(e) = render(json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity)
      def bad_request(e) = render(json: { error: e.message }, status: :bad_request)

      def paginate(col) = col.page(params[:page]).per(params[:per_page] || 20)
      def pagination_meta(col)
        { current_page: col.current_page, total_pages: col.total_pages, total_count: col.total_count }
      end
    end
  end
end
