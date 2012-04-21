class CreateDoormen < ActiveRecord::Migration
  def change
    create_table :doormen do |t|
      t.string :phone

      t.timestamps
    end
  end
end
