class Type < ApplicationRecord
    belongs_to :language
    has_many :articles
    
    def to_param
		"#{id}-#{name.parameterize}"
	end
    
    scope :story, -> {where(name: ['Story', 'Podcast', 'Tema'])}
    scope :notstory, -> {where.not(name: 'Story')}
    scope :notupdate, -> {where.not(name: ['Update', 'Actualizacíon'])}
    scope :notes, -> {where(name: ['Notes', 'Apuntes'])}
    scope :notnotes, -> {where.not(name: ['Notes', 'Apuntes'])}
end
