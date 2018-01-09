class role::test {
  include profile::base

  package { 'awscli':
    ensure => 'present'
  }

  archive { 'C:\\americanblinds-logo.png':
    ensure => present,
    source => 's3://americanblindsmarketingimages/images/americanblinds-logo.png',
  }

}
