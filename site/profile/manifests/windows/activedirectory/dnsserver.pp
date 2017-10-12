# Class: profile::windows::activedirectory::dnsserver
#
#
class profile::windows::activedirectory::dnsserver {
    # Remove all 0's since these are the host portion of the ip
    $network = regsubst( $facts['networking']['network'], '(\.0)+$', '')
    # Extract parts of the ip into an array
    $matches = $network.match(/^(\d+)\.(\d+)\.(\d+)$/)
    # reverse the array to match reverse lookup zone expected format
    # turn array back into dotted notation
    $reversed_network = reverse($matches.delete_at(0)).join('.')


    dsc_xdnsserveradzone { 'Ipv4 Reverse Lookup Zone':
      dsc_ensure           => 'present',
      dsc_name             => "${reversed_network}.in-addr.arpa",
      dsc_replicationscope => 'Forest',
      dsc_dynamicupdate    => 'None',
    }

    dsc_xdnsserveradzone { 'Forward Lookup Zone':
      dsc_ensure           => 'present',
      dsc_name             => 'tragiccode.local',
      dsc_replicationscope => 'Forest',
      dsc_dynamicupdate    => 'Secure',
    }
    # TODO: Find a way to write a unit test for this collector
    # Collect:
    Dsc_xdnsrecord <<| |>>
}
