class Tweet < ApplicationRecord
    require 'aws-sdk'
    
    belongs_to :article, optional: true
    
    has_many :children, class_name: "Tweet", foreign_key: "previous_id"
    belongs_to :previous, class_name: "Tweet", optional: true
end