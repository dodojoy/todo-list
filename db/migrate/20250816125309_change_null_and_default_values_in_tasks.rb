class ChangeNullAndDefaultValuesInTasks < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tasks, :title, false
    change_column_null :tasks, :description, false
    change_column_default :tasks, :concluded, false
  end
end
