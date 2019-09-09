class HikingTrails < ActiveRecord::Migration[6.0]
  def change 
    create_table :hiking_trails do |t|
      t.string :location
    end
  end
end
