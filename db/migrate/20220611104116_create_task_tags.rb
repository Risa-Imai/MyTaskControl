class CreateTaskTags < ActiveRecord::Migration[6.1]
  def change
    create_table :task_tags do |t|
      t.integer :task, null: false, foreign_key: true
      t.integer :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
