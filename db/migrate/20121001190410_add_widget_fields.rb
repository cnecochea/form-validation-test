class AddWidgetFields < ActiveRecord::Migration
  def up
    add_column :widgets, :required_field, :string, null: false, default: ''
    add_column :widgets, :station, :string, null: false, default: ''
    add_column :widgets, :feasibility, :boolean, null: false, default: true
  end

  def down
  end
end
