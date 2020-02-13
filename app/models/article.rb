class Article < ApplicationRecord
    
    belongs_to :language
    belongs_to :status
    belongs_to :type, optional: true
    belongs_to :frame, optional: true
    has_many :tweets
    has_many :translations, class_name: "Article", foreign_key: "original_id"
    belongs_to :original, class_name: "Article", optional: true
    has_many :updates, class_name: "Article", foreign_key: "main_id"
    belongs_to :main, class_name: "Article", optional: true
    has_many :components, class_name: "Article", foreign_key: "story_id"
    belongs_to :story, class_name: "Article", optional: true
    
    def to_param
		"#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{headline.parameterize}"
	end
    
    scope :updates, -> {Article.joins(:type).merge(Type.updates)}
    scope :notupdate, -> {Article.joins(:type).merge(Type.notupdates)}
    scope :nottranslation, -> {where(original_id: '')}
    scope :patrons, -> {Article.joins(:type).merge(Type.patrons)}
    scope :notpatrons, -> {Article.joins(:type).merge(Type.notpatrons)}
    scope :story, -> {Article.joins(:type).merge(Type.story)}
    scope :notstory, -> {Article.joins(:type).merge(Type.notstory)}
    scope :truth, -> {Article.joins(:type).merge(Type.truth)}
    scope :nottruth, -> {Article.joins(:type).merge(Type.nottruth)}
    scope :podcast, -> {Article.joins(:type).merge(Type.podcast)}
    scope :notpodcast, -> {Article.joins(:type).merge(Type.notpodcast)}
    
    scope :toplevelstory, -> {where(story_id: '')}
    scope :topstory, -> {where(:topstory => true)}
    scope :lastone, -> {order('created_at DESC').limit(1)}
    scope :lastfive, -> {order('created_at DESC').limit(5)}
    scope :lastten, -> {order('created_at DESC').limit(10)}
    scope :lasttwenty, -> {order('created_at DESC').limit(20)}
    scope :notlatesttop, -> {where.not(id: topstory.lastone)}
    scope :published, -> {where(status_id: [3, 4])}
    scope :english, -> {where(language_id: 1)}
    scope :spanish, -> {where(language_id: 2)}
    
end
