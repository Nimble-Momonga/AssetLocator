require "ipaddr"

#  Asset Schema
#
#  id
#  name                  varchar(255)
#  primary_locator       varchar(255)
#  ip_address_locator    varchar(255)
#  hostname_locator      varchar(255)
#  url_locator           varchar(255)
#  database_locator      varchar(255)
#  mac_address_locator   varchar(255)
#  netbios_locator       varchar(255)
#  fqdn_locator          varchar(255)
#  file_locator          varchar(255)
#  ec2_locator           varchar(255)
#  application_locator   varchar(255)

class Asset < ActiveRecord::Base

  ORDERED_LOCATORS = [
    :mac_address_locator,
    :netbios_locator,
    :external_ip_address_locator,
    :hostname_locator,
    :url_locator,
    :file_locator,
    :ec2_locator,
    :fqdn_locator,
    :application_locator,
    :ip_address_locator
  ].freeze

  def self.ip_internal?(ip_address)
    ipaddr = IPAddr.new(ip_address)
    ipaddr.private? || ipaddr.loopback?
  end
end
