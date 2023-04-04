# frozen_string_literal: true

# CommentModel
class Comment < ApplicationRecord
  belongs_to :pet
end
