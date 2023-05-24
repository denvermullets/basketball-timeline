class AddYearStartYearEndToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :year_start, :integer
    add_column :teams, :year_end, :integer
  end
end
