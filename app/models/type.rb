class Type < ApplicationRecord
    belongs_to :language
    has_many :articles
    
    def to_param
		"#{id}-#{name.parameterize}"
	end
    
    scope :story, -> {where(name: ['Story', 'Tema'])}
    scope :notstory, -> {where.not(name: ['Story', 'Tema'])}
    scope :patrons, -> {where(name: ['Patrons Column', 'Columna Mecenas'])}
    scope :notpatrons, -> {where.not(name: ['Patrons Column', 'Columna Mecenas'])}

    scope :truth, -> {where(name: ['Truth & Journalism', 'Verdad y Periodismo'])}
    scope :nottruth, -> {where.not(name: ['Truth & Journalism', 'Verdad y Periodismo'])}
    scope :audioreport, -> {where(name: ['Audio Report', 'Crónica Audio'])}
    scope :notaudioreport, -> {where.not(name: ['Audio Report', 'Crónica Audio'])}
    scope :audiointerview, -> {where(name: ['Audio Interview', 'Entrevista Audio'])}
    scope :notaudiointerview, -> {where.not(name: ['Audio Interview', 'Entrevista Audio'])}
    scope :thread, -> {where(name: ['Notes', 'Apuntes'])}
    scope :notthread, -> {where(name: ['Notes', 'Apuntes'])}
    scope :notes, -> {where(name: ['Notes', 'Apuntes'])}
    scope :video, -> {where(name: ['Video', 'Vídeo'])}
    scope :notvideo, -> {where.not(name: ['Video', 'Vídeo'])}
    scope :videoblog, -> {where(name: ['Video Blog', 'Vídeo Blog'])}
    scope :notvideoblog, -> {where.not(name: ['Video Blog', 'Vídeo Blog'])}
    scope :newsletter, -> {where(name: ['Newsletter', 'Boletín'])}
    scope :photo, -> {where(name: ['Photos', 'Fotos'])}
    scope :notphoto, -> {where.not(name: ['Photos', 'Fotos'])}
    scope :notices, -> {where(name: ['Notice', 'Aviso'])}
    scope :live, -> {where(name: ['Live', 'Directo'])}
    
    scope :daily, -> {where(name: ['Newsletter', 'Boletín', 'Live', 'Directo', 'Thread', 'Hilo'])}
    scope :depth, -> {where(name: ['Video', 'Vídeo', 'Photos', 'Fotos'])}
    scope :blog, -> {where(name: ['Blog'])}
    
    scope :english, -> {where(language_id: 1)}
    scope :spanish, -> {where(language_id: 2)}
end
