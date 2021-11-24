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

    locators = prepare(locators)

    sql = table.project(table[Arel.star])
               .where(where_clause(locators))
               .order(order_clause(locators))
               .to_sql

    asset = Asset.find_or_initialize_by(Asset.connection.exec_query(sql).first || { id: nil })
    asset.assign_attributes(locators)

    asset = (asset.new_record? || asset.invalid?) ? asset.dup : asset
    asset.save
    asset.reload
  end

  def self.prepare(locators)
    Hash[locators.reject { |_k, v| v.blank? }
                 .map do |k, v|
                   key = k.match?(/_locator\z/) ? k : "#{k}_locator".to_sym
                   value = Asset::ORDERED_LOCATORS[key].parse_value(v)
                   [key, value]
                 end]
  end

  def self.where_clause(locators)
    locators.map { |k, v| table[k].eq(v) }
            .reduce { |acc, x| acc.or(x) }
  end

  def self.order_clause(locators)
    Asset::ORDERED_LOCATORS.map do |k, strat|
      strat.sort_clause(k, locators)
    end.compact
  end

  def self.table
    Asset.arel_table
  end
end
