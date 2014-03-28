class RenameChildrenAddParent2 < ActiveRecord::Migration
  def change
    rename_table :children, :kids
    rename_column :kids, :parent_id, :parent1_id
    add_column :kids, :parent2_id, :integer
  end
end
