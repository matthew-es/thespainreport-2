class Frame < ApplicationRecord
  belongs_to :language
  has_many :translations, class_name: "Frame", foreign_key: "original_id"
  belongs_to :original, class_name: "Frame", optional: true
  has_many :subscriptions
  has_many :users
  
  scope :original, -> {where(original_id: '')}
end