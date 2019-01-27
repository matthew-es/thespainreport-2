class Type < ApplicationRecord
    belongs_to :language
    has_many :articles
    
    scope :story, -> {where(name: ['Story', 'Podcast', 'Tema'])}
    scope :notstory, -> {where.not(name: 'Story')}
    scope :notupdate, -> {where.not(name: ['Update', 'Actualizacíon'])}
    scope :notes, -> {where(name: ['Notes', 'Apuntes'])}
    scope :notnotes, -> {where.not(name: ['Notes', 'Apuntes'])}
end
