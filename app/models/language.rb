class Language < ApplicationRecord
    has_many :articles
    has_many :types
    has_many :stories
    has_many :teasers
end