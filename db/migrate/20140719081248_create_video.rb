class CreateVideo < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :cover_image
    end
  end
end
