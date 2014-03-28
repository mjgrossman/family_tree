class Changes < ActiveRecord::Migration
  def change

    drop_table :kids

    add_column :people, :parent1_id, :integer
    add_column :people, :parent2_id, :integer
  end
end
