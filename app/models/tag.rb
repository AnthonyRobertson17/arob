# frozen_string_literal:true

class Tag < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: [:user_id, :type] }
  validates :type, presence: true

  scope :for_user, ->(user) { where(user:) }
  scope :ordered, -> { order(id: :desc) }
end
