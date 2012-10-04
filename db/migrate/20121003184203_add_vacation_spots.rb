class AddVacationSpots < ActiveRecord::Migration
  def change
    create_table :vacation_spots do |t|
      t.integer :id
      t.string :name, unique: true
      t.timestamps
    end

    create_table :widget_vacation_spots do |t|
      t.integer :widget_id
      t.integer :vacation_spot_id
    end
  end
end
