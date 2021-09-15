class Article < ApplicationRecord
    
    belongs_to :language
    belongs_to :status
    belongs_to :type, optional: true
    belongs_to :frame, optional: true
    has_many :tweets
    has_many :translations, class_name: "Article", foreign_key: "original_id"
    belongs_to :original, class_name: "Article", optional: true
    has_many :pieces, class_name: "Article", foreign_key: "main_id"
    belongs_to :main, class_name: "Article", optional: true
    has_many :components, class_name: "Article", foreign_key: "story_id"
    belongs_to :story, class_name: "Article", optional: true
    belongs_to :upload, optional: true

    def to_param
		"#{id}-#{created_at.strftime("%y%m%d%H%M%S")}-#{headline.parameterize}"
	end
    
    scope :is_main, -> {where(main_id: '')}
    scope :latestmain, -> {where(main_id: '').order('created_at DESC').limit(1)}
    scope :nottranslation, -> {where(original_id: '')}
    scope :patrons, -> {Article.joins(:type).merge(Type.patrons)}
    scope :notpatrons, -> {Article.joins(:type).merge(Type.notpatrons)}
    scope :story, -> {Article.joins(:type).merge(Type.story)}
    scope :notstory, -> {Article.joins(:type).merge(Type.notstory)}
    scope :truth, -> {Article.joins(:type).merge(Type.truth)}
    scope :nottruth, -> {Article.joins(:type).merge(Type.nottruth)}
    scope :audioreport, -> {Article.joins(:type).merge(Type.audioreport)}
    scope :notaudioreport, -> {Article.joins(:type).merge(Type.notaudioreport)}
    scope :audiointerview, -> {Article.joins(:type).merge(Type.audiointerview)}
    scope :notaudiointerview, -> {Article.joins(:type).merge(Type.notaudiointerview)}
    scope :video, -> {Article.joins(:type).merge(Type.video)}
    scope :notvideo, -> {Article.joins(:type).merge(Type.notvideo)}
    scope :videoblog, -> {Article.joins(:type).merge(Type.videoblog)}
    scope :notvideoblog, -> {Article.joins(:type).merge(Type.notvideoblog)}
    scope :photo, -> {Article.joins(:type).merge(Type.photo)}
    scope :notphoto, -> {Article.joins(:type).merge(Type.notphoto)}
    scope :notes, -> {Article.joins(:type).merge(Type.notes)}
    scope :notices, -> {Article.joins(:type).merge(Type.notices)}
    scope :live, -> {Article.joins(:type).merge(Type.live)}
    scope :daily, -> {Article.joins(:type).merge(Type.daily)}
    scope :depth, -> {Article.joins(:type).merge(Type.depth)}
    
    scope :podcast, -> {Article.where.not(audio_aac_id: "")}
    scope :notpodcast, -> {Article.where(audio_aac_id: "")}
    scope :latestpodcast, -> {Article.podcast.order('created_at DESC').limit(1)}
    scope :notlatestpodcast, -> {where.not(id: podcast.latestpodcast)}
    
    scope :toplevelstory, -> {where(story_id: '')}
    scope :topstory, -> {where(:topstory => true)}
    
    scope :lastfive, -> {order('created_at DESC').limit(5)}
    scope :lastten, -> {order('created_at DESC').limit(10)}
    scope :lasttwenty, -> {order('created_at DESC').limit(20)}

    scope :published, -> {where(status_id: [3, 4])}
    scope :english, -> {where(language_id: 1)}
    scope :spanish, -> {where(language_id: 2)}
   
end
