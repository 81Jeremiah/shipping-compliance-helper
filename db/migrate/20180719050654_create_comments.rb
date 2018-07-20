class CreateComments < ActiveRecord::Migration
  def change
  	create_table :comments do |t|
  		t.text :user_comment
  		t.integer :user_id
  		t.integer :company_id
  		t.timestamps
  	end
  end
end
