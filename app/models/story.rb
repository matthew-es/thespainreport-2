class Story < ApplicationRecord
    belongs_to :language
    belongs_to :status
    has_and_belongs_to_many :articles
    
    has_many :translations, class_name: "Story", foreign_key: "original_id"
    belongs_to :original, class_name: "Story", optional: true
    
    def to_param
		"#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{title.parameterize}"
	end
    
    scope :original, -> {where(original_id: '')}
end
