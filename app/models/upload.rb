class Upload < ApplicationRecord
	require 'aws-sdk'
	
	has_many :versions, class_name: "Upload", foreign_key: "main_id"
	belongs_to :main, class_name: "Upload", optional: true
	has_many :articles
	has_many :tweets
	has_many :prints
	has_many :users, :through => :prints
	
	scope :main, -> {Upload.where(main_id: "")}
	scope :audios_aac, -> {Upload.where(file_type: "audio/aac")}
	scope :audios_mp3, -> {Upload.where(file_type: "audio/mpeg")}
	
	def data_short_name
	 	File.basename(data)
	end
end