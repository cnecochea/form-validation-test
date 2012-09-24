class Widget < ActiveRecord::Base
  attr_accessible :approved_at, :body, :expires_on, :id, :name

  validates_presence_of :name, :body, :expires_on
end
