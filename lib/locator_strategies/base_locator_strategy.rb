class BaseLocatorStrategy
  def self.parse_value(str)
    str
  end

  def self.sort_clause(k, locators)
    locators[k].present? ? table[k].desc : nil
  end

  def self.primary_locator(k, asset)
    asset.send(k).nil? ? nil : k[/\A(.*)(_locator)\z/, 1]
  end

  def self.table
    Asset.arel_table
  end
end
