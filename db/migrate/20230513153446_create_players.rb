class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :short_name
      t.string :headshot_url
      t.string :reference_url, null: false

      t.timestamps
    end
  end
end
