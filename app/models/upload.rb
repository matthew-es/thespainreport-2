class Upload < ApplicationRecord
	require 'aws-sdk'
	
	has_many :versions, class_name: "Upload", foreign_key: "main_id"
    belongs_to :main, class_name: "Upload", optional: true
    
    has_many :photoessays
    has_many :articles, through: :photoessays
    
    has_many :tweets
    
    scope :main, -> {Upload.where(main_id: "")}
    scope :images, -> {Upload.where(File.extname(data: ['.jpg', '.jpeg']))}
end