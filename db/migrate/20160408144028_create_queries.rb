class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.integer :macs
      t.string :vendor
      t.string :base
      t.string :s, default: ":"

      t.timestamps null: false
    end
  end
end
