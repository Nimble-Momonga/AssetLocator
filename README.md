## Asset Locator

An _asset_ is a computer, server, network device, or anything else that a
vulnerability scanner can scan and report on. Vulnerability scanners will give the application various data about an asset. An IP address, a MAC addres, a hostname, an EC2 identifier, etc. However, not all scanners provide every attribute and sometimes the attributes change.

For this reason, we have an `AssetLocator` service that takes a combination of these attributes and finds (or creates) the appropriate `Asset` in our system.

The question becomes, given serveral attributes how do we find the right asset? And which attribute is a better indicator? For example, a MAC address is much less likely to change than a hostname so we prioritize the MAC address over a hostname.

The goal of this exercise it to work together to implement the code necessary to make as many of the tests pass as time allows. It's an open-book exercise and questions are encouraged.

## Getting Started

### Using Docker:

If you have docker installed it's as easy as running `docker-compose up`. However, if you want to throw a `binding.pry` in the code to do some digging you will need to run:

```
docker-compose run --rm ruby
```

### Not Using Docker:

You will need to have the following software installed:

1. Ruby (2.5.7)
2. The `bundler` gem (>= 1.17.3)
2. Sqlite3 development libraries. Try:

	```
	# Macos
	brew install sqlite3
	
	# Fedora (or any dnf based package manager)
	dnf install sqlite-devel
	
	# Ubuntu (or any aptitude based package manager)
	apt-get install libsqlite3-dev
	```

3. Navigate to the new project: `cd asset_locator`

4. Install gems: `bundle install`

5. Set up the database: `RAILS_ENV=test bundle exec rake db:setup`

6. Run the tests: `bundle exec rake spec`

7. One test will pass, one will fail, and the rest will be pending.

8. Feel free to browse around, but don't start coding until the interview starts.
