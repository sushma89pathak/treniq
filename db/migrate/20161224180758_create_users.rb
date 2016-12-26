class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.date :date_of_birth
      t.float :salary
      t.string :location

      t.timestamps
    end
  end
end
