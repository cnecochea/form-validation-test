class Widget < ActiveRecord::Base
  attr_accessible :approved_at, :body, :expires_on, :id, :name,
    :required_field, :station, :feasibility

  validates_presence_of :body, :expires_on, :required_field, :station, :feasibility
  validates :name, presence: true,
    format: { with: /i/ }
end
