class Campaign < ApplicationRecord
  belongs_to :language
  
  has_many :translations, class_name: "Campaign", foreign_key: "original_id"
  belongs_to :original, class_name: "Campaign", optional: true
  
  scope :original, -> {where(original_id: '')}
end
