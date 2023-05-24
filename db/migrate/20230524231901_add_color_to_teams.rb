class AddColorToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :color, :string
  end
end
