class Type < ApplicationRecord
    belongs_to :language
    has_many :articles
    
    def to_param
		"#{id}-#{name.parameterize}"
	end
    
    scope :story, -> {where(name: ['Story', 'Podcast', 'Tema'])}
    scope :notstory, -> {where.not(name: ['Story', 'Tema', 'Podcast'])}
    scope :notupdate, -> {where.not(name: ['Update', 'Actualización'])}
    scope :notes, -> {where(name: ['Notes', 'Apuntes'])}
    scope :notnotes, -> {where.not(name: ['Notes', 'Apuntes'])}
    scope :english, -> {where(language_id: 1)}
    scope :spanish, -> {where(language_id: 2)}
end
