class CreateTagMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_maps do |t|
      t.references :post, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
    
    add_index :tag_maps, [:post_id, :tag_id], unique: true
  end
end
