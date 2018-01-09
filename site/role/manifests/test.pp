class role::test {
  include profile::base

  package { 'awscli':
    ensure   => 'present',
    provider => 'chocolatey',
  }

  archive { 'C:\\americanblinds-logo.png':
    ensure => present,
    source => 's3://americanblindsmarketingimages/images/americanblinds-logo.png',
  }

}
