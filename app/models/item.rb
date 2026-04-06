class Item < ApplicationRecord
  belongs_to :user
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :title,       presence: true, length: { minimum: 3, maximum: 200 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :price,       numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status,      inclusion: { in: %w[draft published archived] }

  before_validation { self.status ||= 'draft'; self.metadata ||= {} }
  before_save { self.slug = title.parameterize if title_changed? }

  enum :status, { draft: 0, published: 1, archived: 2 }, default: :draft

  scope :published,  -> { where(status: :published) }
  scope :recent,     -> { order(created_at: :desc) }
  scope :for_user,   ->(u) { where(user: u) }

  def self.search(q) = q.present? ? where('title ILIKE ? OR description ILIKE ?', "%#{q}%", "%#{q}%") : all
end
