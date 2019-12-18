class Bookmark < ApplicationRecord
    belongs_to :user
    belongs_to :article, optional: true
    belongs_to :campaign, optional: true
end
