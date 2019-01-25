class Article < ApplicationRecord
    belongs_to :language
    belongs_to :status
    belongs_to :type, optional: true
    belongs_to :campaign, optional: true
    
    has_many :translations, class_name: "Article", foreign_key: "original_id"
    belongs_to :original, class_name: "Article", optional: true
    
    has_many :updates, class_name: "Article", foreign_key: "main_id"
    belongs_to :main, class_name: "Article", optional: true
    
    has_many :components, class_name: "Article", foreign_key: "story_id"
    belongs_to :story, class_name: "Article", optional: true
    
    def to_param
		"#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{headline.parameterize}"
	end
    
    scope :notupdate, -> {where(main_id: '')}
    scope :nottranslation, -> {where(original_id: '')}
    scope :story, -> {Article.joins(:type).merge(Type.story)}
    scope :notstory, -> {Article.joins(:type).merge(Type.notstory)}
    scope :notes, -> {Article.joins(:type).merge(Type.notes)}
    scope :notnotes, -> {Article.joins(:type).merge(Type.notnotes)}
    scope :toplevelstory, -> {where(story_id: '')}
    scope :topstory, -> {where(:topstory => true)}
    scope :lastone, -> {order('created_at DESC').limit(1)}
    scope :notlatesttop, -> {where.not(id: topstory.lastone)}
    scope :lastten, -> {order('created_at DESC').limit(10)}
    scope :published, -> {where(status_id: [3, 4])}
    scope :english, -> {where(language_id: 1)}
    scope :spanish, -> {where(language_id: 2)}
end
