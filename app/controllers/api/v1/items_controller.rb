module Api
  module V1
    class ItemsController < BaseController
      before_action :set_item, only: [:show, :update, :destroy, :publish, :archive]

      def index
        items = Item.for_user(current_user).page(params[:page]).per(params[:per_page] || 20)
        render json: items, each_serializer: ItemSerializer
      end

      def show = render(json: @item, serializer: ItemSerializer)

      def create
        item = current_user.items.create!(item_params)
        render json: item, serializer: ItemSerializer, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      def update
        @item.update!(item_params)
        render json: @item, serializer: ItemSerializer
      end

      def destroy = @item.destroy! && head(:no_content)

      def search
        items = Item.search(params[:q]).page(params[:page])
        render json: items, each_serializer: ItemSerializer
      end

      def publish
        @item.update!(status: 'published', published_at: Time.current)
        render json: @item, serializer: ItemSerializer
      end

      def archive
        @item.update!(status: 'archived')
        render json: @item, serializer: ItemSerializer
      end

      private
      def set_item = (@item = Item.find(params[:id]))
      def item_params = params.require(:item).permit(:title, :description, :price, :status, :metadata)
    end
  end
end
