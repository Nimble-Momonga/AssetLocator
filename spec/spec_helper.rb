require "factory_bot"
require "pry"
require "standalone_migrations"

require "asset_locator"

RSpec.configure do |config|
  config.expose_dsl_globally = false

  config.before(:suite) do
    FactoryBot.find_definitions

    ActiveRecord::Base.logger = Logger.new("/dev/null")

    ActiveRecord::Base.establish_connection(
      StandaloneMigrations::Configurator.new.config_for("test")
    )

  end

  config.before(:each) do
    ActiveRecord::Base.connection.execute("DELETE FROM assets;")
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence " \
                                          "WHERE name='assets';")
  end
end
