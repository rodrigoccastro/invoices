class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :number
      t.datetime :date
      t.string :company
      t.string :payer
      t.float :value
      t.string :emails

      t.timestamps
    end
  end
end
