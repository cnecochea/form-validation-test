class VacationSpot < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :widgets, join_table: 'widget_vacation_spots'
end
