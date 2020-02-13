class Type < ApplicationRecord
    belongs_to :language
    has_many :articles
    
    def to_param
		"#{id}-#{name.parameterize}"
	end
    
    scope :story, -> {where(name: ['Story', 'Tema'])}
    scope :notstory, -> {where.not(name: ['Story', 'Tema'])}
    scope :patrons, -> {where(name: ['Patrons only', 'Sólo mecenas'])}
    scope :notpatrons, -> {where.not(name: ['Patrons only', 'Sólo mecenas'])}
    scope :updates, -> {where(name: ['Update', 'Actualización'])}
    scope :notupdates, -> {where.not(name: ['Update', 'Actualización'])}
    scope :truth, -> {where(name: ['Truth & Journalism', 'Verdad y Periodismo'])}
    scope :nottruth, -> {where.not(name: ['Truth & Journalism', 'Verdad y Periodismo'])}
    scope :podcast, -> {where(name: 'Podcast')}
    scope :notpodcast, -> {where.not(name: 'Podcast')}
    scope :thread, -> {where(name: ['Thread', 'Hilo'])}
    scope :english, -> {where(language_id: 1)}
    scope :spanish, -> {where(language_id: 2)}
end
