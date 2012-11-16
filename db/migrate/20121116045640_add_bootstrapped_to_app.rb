class AddBootstrappedToApp < ActiveRecord::Migration
  def change
  	add_column :apps, :bootstraped, :integer, :default => 0
  end
end
