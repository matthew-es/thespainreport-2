class Article < ApplicationRecord
    belongs_to :language
    belongs_to :status
    belongs_to :type, optional: true
    belongs_to :campaign, optional: true
    has_and_belongs_to_many :stories
    
    has_many :translations, class_name: "Article", foreign_key: "original_id"
    belongs_to :original, class_name: "Article", optional: true
    
    has_many :updates, class_name: "Article", foreign_key: "main_id"
    belongs_to :main, class_name: "Article", optional: true
    
    def to_param
		"#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{headline.parameterize}"
	end
    
    scope :original, -> {where(original_id: '')}
end
