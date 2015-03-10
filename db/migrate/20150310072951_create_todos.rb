class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :task
      t.boolean :complete

      t.timestamps null: false
    end
  end
end
