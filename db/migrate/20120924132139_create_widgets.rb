class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :id
      t.string :name
      t.text :body
      t.timestamp :approved_at
      t.date :expires_on

      t.timestamps
    end
  end
end
