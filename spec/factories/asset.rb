FactoryBot.define do
  factory :asset do
    sequence(:name) { |n| "Asset #{n}" }

    trait :with_internal_ip_address do
      primary_locator { "ip_address" }
      ip_address_locator { "192.168.2.1" }
    end

    trait :with_external_ip_address do
      primary_locator { "ip_address" }
      ip_address_locator { "79.34.242.138" }
    end

    trait :with_hostname do
      primary_locator { "hostname" }
      hostname_locator { "com-2k8-32-87.patch.ad.vuln.qa.example.com" }
    end

    trait :with_mac_address do
      primary_locator { "mac_address" }
      mac_address_locator { "0a:b4:97:00:08:b3" }
    end

    trait :with_netbios do
      primary_locator { "netbios" }
      netbios_locator { "NETBIOS_LOC" }
    end

    trait :with_database do
      primary_locator { "database" }
      database_locator { "mysql" }
    end

    trait :with_application do
      primary_locator { "application" }
      application_locator { "a_application_loc" }
    end

    trait :with_ec2 do
      primary_locator { "ec2" }
      ec2_locator { "ec2_test_loc" }
    end
  end
end
