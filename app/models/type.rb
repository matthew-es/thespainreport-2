class Type < ApplicationRecord
    belongs_to :language
    has_many :articles
end
