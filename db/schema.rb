# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_11_223918) do

  create_table "assets", force: :cascade do |t|
    t.string "name"
    t.string "primary_locator"
    t.string "ip_address_locator"
    t.string "hostname_locator"
    t.string "url_locator"
    t.string "database_locator"
    t.string "mac_address_locator"
    t.string "netbios_locator"
    t.string "fqdn_locator"
    t.string "file_locator"
    t.string "ec2_locator"
    t.string "application_locator"
  end

end
