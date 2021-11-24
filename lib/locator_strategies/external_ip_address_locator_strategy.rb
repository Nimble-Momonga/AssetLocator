require_relative "base_locator_strategy"

class ExternalIpAddressLocatorStrategy < BaseLocatorStrategy
  def self.sort_clause(_k, locators)
    ip_address = locators[:ip_address_locator]
    ip_address.present? && Asset.ip_internal?(ip_address) ? table[:ip_address_locator].desc : nil
  end

  def self.primary_locator(_k, asset)
    ip_address = asset.send(:ip_address_locator)
    ip_address.nil? || Asset.ip_internal?(ip_address) ? nil : :ip_address
  end
end
