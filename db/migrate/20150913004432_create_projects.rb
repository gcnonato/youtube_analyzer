class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :price_plan
      t.string :url
      t.string :usage

      t.timestamps null: false
    end
  end
end
