module Api
  module V1
    class UsersController < BaseController
      before_action :require_admin!, only: [:index, :destroy]
      before_action :set_user, only: [:show, :update, :destroy, :activate, :deactivate]

      def index
        users = User.all.page(params[:page]).per(20)
        render json: users, each_serializer: UserSerializer
      end

      def show = render(json: @user, serializer: UserSerializer)

      def update
        @user.update!(user_params)
        render json: @user, serializer: UserSerializer
      end

      def destroy = @user.destroy! && head(:no_content)
      def activate = @user.update!(status: :active) && render(json: @user, serializer: UserSerializer)
      def deactivate = @user.update!(status: :inactive) && render(json: @user, serializer: UserSerializer)

      private
      def set_user = (@user = User.find(params[:id]))
      def user_params = params.require(:user).permit(:name, :email)
      def require_admin! = render(json: { error: 'Forbidden' }, status: :forbidden) unless current_user.admin?
    end
  end
end
