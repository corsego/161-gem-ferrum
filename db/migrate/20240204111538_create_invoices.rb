class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.string :email
      t.string :product
      t.string :price
      t.string :quantity
      t.string :total

      t.timestamps
    end
  end
end
