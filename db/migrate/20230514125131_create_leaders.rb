class CreateLeaders < ActiveRecord::Migration[7.0]
  def change
    create_table :leaders do |t|
      t.string :name
      t.string :url
      t.string :headshot_url

      t.timestamps
    end
  end
end
