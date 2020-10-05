class Photoessay < ApplicationRecord
    belongs_to :article, optional: true
    belongs_to :upload, optional: true
end
