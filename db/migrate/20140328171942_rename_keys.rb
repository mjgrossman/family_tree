class RenameKeys < ActiveRecord::Migration
  def change
    rename_column :people, :parent1_id, :mother_id
    rename_column :people, :parent2_id, :father_id
  end
end
