class SeedVacationSpots < ActiveRecord::Migration
  def up
    ['The French Riviera', 'The Hamptons', 'The Vineyard', 'Sonoma', 'Baltimore'].each do |spot|
      VacationSpot.create(name: spot)
    end
  end

  def down
  end
end
