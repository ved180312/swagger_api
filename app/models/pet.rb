class Pet < ApplicationRecord
    has_many :comments, dependent: :destroy
end
