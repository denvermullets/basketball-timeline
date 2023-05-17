class AddYearAndPlayoffsToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :playoffs, :boolean, default: false
    add_column :games, :year, :integer
  end
end
