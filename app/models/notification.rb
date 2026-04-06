class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true

  validates :kind,    presence: true
  validates :message, presence: true

  scope :unread,  -> { where(read: false) }
  scope :recent,  -> { order(created_at: :desc) }

  def mark_read! = update!(read: true)

  def self.mark_all_read_for(user)
    where(user: user, read: false).update_all(read: true)
  end
end
