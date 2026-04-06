class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :role, :status, :created_at, :last_login_at
  def created_at    = object.created_at.iso8601
  def last_login_at = object.last_login_at&.iso8601
end
