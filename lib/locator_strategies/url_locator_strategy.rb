require_relative "base_locator_strategy"

class UrlLocatorStrategy < BaseLocatorStrategy
  def self.parse_value(str)
    str.match?(/\Ahttp:\/\//) ? str : "http://#{str}"
  end
end
