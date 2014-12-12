class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.boolean :pappypresent
      t.boolean :ordersent
      t.boolean :textsent

      t.timestamps
    end
  end
end
