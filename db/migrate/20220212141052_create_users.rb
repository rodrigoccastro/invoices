class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :token_main
      t.string :token_temp

      t.timestamps
    end
  end
end
