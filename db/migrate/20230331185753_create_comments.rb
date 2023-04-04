# frozen_string_literal: true

# CreateComments
class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :pet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
