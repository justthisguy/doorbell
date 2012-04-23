class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start
      t.integer :duration
      t.string :frequency
      t.string :reserves

      t.timestamps
    end
  end
end
