# Class: profile::windows::dnsclient
#
#
class profile::windows::dnsclient(
  Pattern[/^\d+\.\d+\.\d+\.\d+$/] $primary_dnsserver_internal_ipv4_address,
  Pattern[/^\d+\.\d+\.\d+\.\d+$/] $alternate_dnsserver_internal_ipv4_address,
) {

    dsc_xdnsserveraddress { 'DnsServerAddresses':
        ensure             => 'present',
        dsc_address        =>  [ $primary_dnsserver_internal_ipv4_address, $alternate_dnsserver_internal_ipv4_address ],
        dsc_interfacealias => 'Ethernet 2',
        dsc_addressfamily  => 'IPv4',
        # dsc_validate       => true,
  }
}
