class CreateTeamLeaders < ActiveRecord::Migration[7.0]
  def change
    create_table :team_leaders do |t|
      t.belongs_to :team, foreign_key: "team_id"
      t.belongs_to :leader, foreign_key: "leader_id"

      t.timestamps
    end
  end
end
