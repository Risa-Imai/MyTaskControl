class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.integer :customer_id
      t.string :title
      t.integer :progress_status

      t.timestamps
    end
  end
end
