require "active_record"
require_relative "models/asset"

# Asset Schema
#   id
#   name                  varchar(255)
#   primary_locator       varchar(255)
#   ip_address_locator    varchar(255)
#   hostname_locator      varchar(255)
#   url_locator           varchar(255)
#   database_locator      varchar(255)
#   mac_address_locator   varchar(255)
#   netbios_locator       varchar(255)
#   fqdn_locator          varchar(255)
#   file_locator          varchar(255)
#   ec2_locator           varchar(255)
#   application_locator   varchar(255)


module AssetLocator
  def self.retrieve(locators)
    raise RuntimeError if locators == {}
    # When given a hash of locators,
    # this method should return a single asset.
    #
    # Place your logic here.
    #
  end
end
