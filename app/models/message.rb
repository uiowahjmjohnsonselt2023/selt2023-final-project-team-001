class Message < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"

  validates :sender_id, presence: true
  validates :sender_name, presence: true
  validates :receiver_name, presence: true
  validates :receiver_id, presence: true
  validates :message, presence: true, length: {maximum: 500}
  validates :subject, presence: true, length: {maximum: 100}
end
