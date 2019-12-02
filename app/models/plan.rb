class Plan < ApplicationRecord
    belongs_to :language
    
    has_many :translations, class_name: "Plan", foreign_key: "original_id"
    belongs_to :original, class_name: "Plan", optional: true
    
    scope :original, -> {where(original_id: '')}
    scope :english, -> {where(language_id: 1)}
    scope :spanish, -> {where(language_id: 2)}
end
