module Api
  module V1
    class AuthController < ActionController::API
      def register
        result = AuthService.register(register_params)
        result[:success] ? render(json: result[:data], status: :created) :
          render(json: { errors: result[:errors] }, status: :unprocessable_entity)
      end

      def login
        result = AuthService.login(params[:email], params[:password])
        result[:success] ? render(json: result[:data]) :
          render(json: { error: result[:error] }, status: :unauthorized)
      end

      def refresh
        token = request.headers['Authorization']&.split(' ')&.last
        result = AuthService.refresh_token(token)
        result[:success] ? render(json: result[:data]) :
          render(json: { error: result[:error] }, status: :unauthorized)
      end

      def logout = render(json: { message: 'Logged out' })

      private
      def register_params = params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end
  end
end
