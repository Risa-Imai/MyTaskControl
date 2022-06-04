class CreateTaskComments < ActiveRecord::Migration[6.1]
  def change
    create_table :task_comments do |t|
      t.integer :customer_id
      t.integer :task_id
      t.text :comment

      t.timestamps
    end
  end
end
