class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|

      t.timestamps null: false
    end
  end
end
