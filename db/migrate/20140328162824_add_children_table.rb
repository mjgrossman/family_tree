class AddChildrenTable < ActiveRecord::Migration
  def change

    create_table :children do |t|
      t.integer :person_id
      t.integer :parent_id
    end

  end
end
