# Class: profile::linux::base
#
#
class profile::linux::base(
    String $domain_name,
) {

  @@dsc_xdnsrecord { 'ARecord':
    dsc_ensure => 'present',
    dsc_name   => $facts['hostname'],
    dsc_target => $facts['networking']['ip'],
    dsc_type   => 'ARecord',
    dsc_zone   => $domain_name,
  }

  # TODO: implement reverse lookup record export

}