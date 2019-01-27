class Plan < ApplicationRecord
    belongs_to :language
    
    has_many :translations, class_name: "Plan", foreign_key: "original_id"
    belongs_to :original, class_name: "Plan", optional: true
    
    scope :original, -> {where(original_id: '')}
end
