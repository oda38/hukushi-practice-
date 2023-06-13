# frozen_string_literal: true

# This migration comes from gutentag (originally 2)
class GutentagCacheCounter < ActiveRecord::Migration[4.2]
  def up
    add_column :gutentag_tags, :taggings_count, :integer, :default => 0
    add_index  :gutentag_tags, :taggings_count

  end

  def down
    remove_column :gutentag_tags, :taggings_count
  end
end
