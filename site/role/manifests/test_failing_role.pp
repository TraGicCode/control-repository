class role::test_failing_role {


  package { 'awscli':
    ensure   => 'present',
    provider => 'chocolatey',
  }


}
