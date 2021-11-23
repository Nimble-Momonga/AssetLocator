class CreateAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :assets do |t|
      t.string :name
      t.string :primary_locator
      t.string :ip_address_locator
      t.string :hostname_locator
      t.string :url_locator
      t.string :database_locator
      t.string :mac_address_locator
      t.string :netbios_locator
      t.string :fqdn_locator
      t.string :file_locator
      t.string :ec2_locator
      t.string :application_locator
    end
  end
end
