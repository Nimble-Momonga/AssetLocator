require "ipaddr"
require_relative "../locator_strategies/url_locator_strategy"
require_relative "../locator_strategies/external_ip_address_locator_strategy"

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

  validate :matches_primary_locator, on: :update
  before_save :update_primary_locator

  ORDERED_LOCATORS = {
    mac_address_locator: BaseLocatorStrategy,
    netbios_locator: BaseLocatorStrategy,
    external_ip_address_locator: ExternalIpAddressLocatorStrategy,
    hostname_locator: BaseLocatorStrategy,
    url_locator: UrlLocatorStrategy,
    file_locator: BaseLocatorStrategy,
    ec2_locator: BaseLocatorStrategy,
    fqdn_locator: BaseLocatorStrategy,
    application_locator: BaseLocatorStrategy,
    ip_address_locator: BaseLocatorStrategy
  }.freeze

  def self.ip_internal?(ip_address)
    ipaddr = IPAddr.new(ip_address)
    ipaddr.private? || ipaddr.loopback?
  end

  private

  def matches_primary_locator
    unless (send("#{primary_locator}_locator") == send("#{primary_locator}_locator_was"))
      errors.add(:primary_locator, "mismatch on primary locator")
    end
  end

  def update_primary_locator
    ORDERED_LOCATORS.each do |k, strat|
      new_primary_locator = strat.primary_locator(k, self)
      next if new_primary_locator.nil?

      self.primary_locator = new_primary_locator
      break
    end
  end
end
