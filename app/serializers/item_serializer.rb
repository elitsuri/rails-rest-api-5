class ItemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :status, :slug, :metadata, :published_at, :created_at
  belongs_to :user, serializer: UserSerializer
  def price        = object.price&.to_f
  def published_at = object.published_at&.iso8601
end
