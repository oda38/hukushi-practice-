class ChangeProfileImagesToPostImages < ActiveRecord::Migration[7.0]
  def change
    rename_table :profile_images, :post_images
  end
end
