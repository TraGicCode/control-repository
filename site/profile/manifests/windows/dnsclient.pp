# Class: profile::windows::dnsclient
#
#
class profile::windows::dnsclient(
  Pattern[/^\d+\.\d+\.\d+\.\d+$/] $primary_dnsserver_internal_ipv4_address,
  Pattern[/^\d+\.\d+\.\d+\.\d+$/] $alternate_dnsserver_internal_ipv4_address,
) {

  #   dsc_xdnsserveraddress { 'DnsServerAddresses':
  #       ensure             => 'present',
  #       dsc_address        =>  [ $primary_dnsserver_internal_ipv4_address, $alternate_dnsserver_internal_ipv4_address ],
  #       dsc_interfacealias => $facts['networking']['primary'],
  #       dsc_addressfamily  => 'IPv4',
  #       # dsc_validate       => true,
  # }

  # Loop through all network interfaces
  # Mainly needed for SQL Server Fail over clustering
  $facts['networking']['interfaces'].each |$key, $value| {
    dsc_xdnsserveraddress { "Configure-Dns-Server-For-${key}-interface":
          ensure             => 'present',
          dsc_address        =>  [ $primary_dnsserver_internal_ipv4_address, $alternate_dnsserver_internal_ipv4_address ],
          dsc_interfacealias => $key,
          dsc_addressfamily  => 'IPv4',
          # dsc_validate       => true,
    }
  }
}