require "spec_helper"

RSpec.describe "Retrieves an Asset based on Locator info" do
  let!(:internal_ip_asset) { FactoryBot.create(:asset, :with_internal_ip_address) }
  let!(:hostname_asset)    { FactoryBot.create(:asset, :with_hostname) }
  let!(:mac_address_asset) { FactoryBot.create(:asset, :with_mac_address, file_locator: "") }
  let!(:netbios_asset)     { FactoryBot.create(:asset, :with_netbios) }
  let!(:application_asset) { FactoryBot.create(:asset, :with_application) }
  let!(:ec2_asset)         { FactoryBot.create(:asset, :with_ec2) }

  it "raises an error with no locators" do
    expect { AssetLocator.retrieve({}) }.to raise_error(RuntimeError)
  end

  it "finds the asset with a single locator" do
    asset = AssetLocator.retrieve(ip_address: internal_ip_asset.ip_address_locator)
    expect(asset).to eq(internal_ip_asset)
  end

  xit "finds the asset when multiple locators are present" do
    asset = AssetLocator.retrieve(ip_address: "10.0.0.1",
                                  ec2: "ec2_locator",
                                  hostname: hostname_asset.hostname_locator)
    expect(asset).to eq(hostname_asset)
  end

  xit "uses the highest ranked locator to find an asset" do
    asset = AssetLocator.retrieve(mac_address: mac_address_asset.mac_address_locator,
                                  application: application_asset.application_locator,
                                  ec2: "fake_ec2_locator",
                                  hostname: hostname_asset.hostname_locator)
    expect(asset).to eq(mac_address_asset)
  end

  xit "ignore higher ranked locators if they do not match any assets" do
    asset = AssetLocator.retrieve(mac_address: "123abc456cde",
                                  application: application_asset.application_locator,
                                  ec2: "fake_ec2_locator",
                                  netbios: netbios_asset.netbios_locator)
    expect(asset).to eq(netbios_asset)
  end

  xit "ignores locator keys with blank values" do
    asset = AssetLocator.retrieve(mac_address: nil,
                                  file: "",
                                  ip_address: internal_ip_asset.ip_address_locator)
    expect(asset).to eq(internal_ip_asset)
  end

  xit "doesn't query with locator keys that have blank values" do
    expect(Asset).to receive(:find_by).once
    AssetLocator.retrieve(mac_address: nil,
                          file: "",
                          ip_address: internal_ip_asset.ip_address_locator)
  end

  xit "adds the http prefix to url locator" do
    asset_in_db = FactoryBot.create(:asset,
                                     url_locator: "http://me.com")
    asset = AssetLocator.retrieve(url: "me.com")
    expect(asset).to eq(asset_in_db)
  end

  context "no matching assets in db" do
    # incoming
    # mac -> a
    # h -> b
    xit "creates a new asset" do
      start_count = Asset.count
      asset = AssetLocator.retrieve(hostname: "some.hostname",
                                    mac_address: "0a:b4:100:99:08:b3")

      expect(Asset.count).to eq(start_count + 1)
    end

    # incoming
    # mac -> a
    # h -> b
    xit "sets mac address(higher ranked locator) as primary locator" do
      asset = AssetLocator.retrieve(hostname: "some.hostname",
                                    mac_address: "0a:b4:100:99:08:b3")

      expect(asset.primary_locator).to eq("mac_address")
    end

    # incoming
    # ip -> a(external)
    # h -> b
    xit "creates a new asset and sets external IP(higher ranked locator) as primary locator" do
      start_count = Asset.count
      asset = AssetLocator.retrieve(hostname: "some.hostname",
                                    ip_address: "78.32.98.157")

      expect(Asset.count).to eq(start_count + 1)
      expect(asset.primary_locator).to eq("ip_address")
    end
  end

  context "there is a matching asset in the db" do
    # incoming            | in DB
    # h   -               | h  -> a
    # ip -> b(internal)   | ip -> b(internal)
    xit "finds the asset by internal IP, when that is the only locator" do
      asset_in_db = FactoryBot.create(:asset,
                                       :with_internal_ip_address,
                                       :with_hostname)

      asset = AssetLocator.retrieve(ip_address: asset_in_db.ip_address_locator)
      expect(asset).to eq(asset_in_db)
    end

    # incoming            | in DB
    # h -> a              | h -> a
    # ip -> b(internal)   | ip   -
    xit "finds the asset by hostname, internal IP not needed" do
      asset_in_db = FactoryBot.create(:asset, :with_hostname)

      asset = AssetLocator.retrieve(ip_address: "192.168.2.14",
                                    hostname: asset_in_db.hostname_locator)

      expect(asset).to eq(asset_in_db)
    end

    # incoming            | in DB
    # h -> a              | h -> a
    # ip -> b(internal)   | ip -> c(internal)
    xit "finds the asset by hostname and updates lower ranked locators" do
      asset_in_db = FactoryBot.create(:asset,
                                       :with_hostname,
                                       ip_address_locator: "192.168.2.1",
                                       url_locator: "test.com")

      asset = AssetLocator.retrieve(ip_address: "192.168.2.14",
                                    hostname: asset_in_db.hostname_locator,
                                    url: "new_test.com")

      expect(asset).to eq(asset_in_db)
      expect(asset.ip_address_locator).to eq("192.168.2.14")
      expect(asset.url_locator).to eq("new_test.com")
    end

    # incoming            | in DB
    # ip -> b(external)   | ip   -
    # h -> a              | h -> a
    xit "finds the asset by hostname and improves primary locator" do
      asset_in_db = FactoryBot.create(:asset, :with_hostname)
      expect(asset_in_db.primary_locator).to eq("hostname")

      asset = AssetLocator.retrieve(ip_address: "79.153.48.235",
                                    hostname: asset_in_db.hostname_locator)

      expect(asset).to eq(asset_in_db)
      expect(asset.primary_locator).to eq("ip_address")
    end
  end

  context "asset in db with mismatched higher locator" do
    # incoming            | in DB
    # mac -> b            | mac -> c
    # h -> a              | h  -> a
    xit "creates a new asset when hostname matches, but mac_address does not" do
      asset_in_db = FactoryBot.create(:asset,
                                       :with_mac_address,
                                       :with_hostname)
      start_count = Asset.count

      asset = AssetLocator.retrieve(mac_address: "new:mac:address",
                                    hostname: asset_in_db.hostname_locator)
      expect(asset).not_to eq(asset_in_db)
      expect(Asset.count).to eq(start_count + 1)
    end

    # incoming            | in DB
    # h -> a              | h  -> b
    # ip -> c(internal)   | ip -> c(internal)
    xit "creates a new asset when internal IP matches, but hostname does not" do
      asset_in_db = FactoryBot.create(:asset,
                                       :with_internal_ip_address,
                                       :with_hostname)
      start_count = Asset.count

      asset = AssetLocator.retrieve(ip_address: asset_in_db.ip_address_locator,
                                    hostname: "some.hostname")
      expect(asset).not_to eq(asset_in_db)
      expect(Asset.count).to eq(start_count + 1)
    end
  end

  xit "handles url locator properly when it has _locator" do
    # sometimes we get the "_locator" suffix
    asset_in_db = FactoryBot.create(:asset,
                                     url_locator: "http://me.com")

    asset = AssetLocator.retrieve(url_locator: "me.com")

    expect(asset).to eq(asset_in_db)
  end
end
