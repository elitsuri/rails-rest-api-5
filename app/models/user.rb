class User < ApplicationRecord
  has_secure_password
  has_many :items, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name,  presence: true, length: { minimum: 2, maximum: 100 }
  validates :password, length: { minimum: 8 }, if: :password_required?

  before_save { self.email = email.downcase.strip }

  enum :role,   { user: 0, admin: 1, moderator: 2 }, default: :user
  enum :status, { active: 0, inactive: 1, banned: 2 }, default: :active

  scope :active,  -> { where(status: :active) }
  scope :admins,  -> { where(role: :admin) }
  scope :recent,  -> { order(created_at: :desc) }

  def admin? = role == 'admin'

  private
  def password_required? = new_record? || password.present?
end
