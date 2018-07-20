class CreateCompanies < ActiveRecord::Migration
  def change
  	create_table :companies do |t|
  		t.string :name
  		t.text :shipping_container_notes
  		t.text :label_notes
  		t.text :asn_notes
  		t.text :routing_notes
  		t.integer :user_id
  		t.timestamps
  	end
  end
end
