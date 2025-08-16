class ChangeDescriptionNullableInTasks < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tasks, :description, true
  end
end
