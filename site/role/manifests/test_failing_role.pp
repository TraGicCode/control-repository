class role::test {


  package { 'awscli':
    ensure   => 'present',
    provider => 'chocolatey',
  }


}
