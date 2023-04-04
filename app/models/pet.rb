# frozen_string_literal: true

# PetModel
class Pet < ApplicationRecord
  has_many :comments, dependent: :destroy
end
