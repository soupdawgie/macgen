class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.integer :amount
      t.string :vendor
      t.string :start
      t.string :separator, default: ":"

      t.timestamps null: false
    end
  end
end
