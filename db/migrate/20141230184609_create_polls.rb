class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title, null: false
      t.integer :author_id

      t.timestamps null: false
    end

    add_index(:polls, :title, unique: true)
  end
end