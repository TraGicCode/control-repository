class role::test_failing_role {


  package { 'awsclid':
    ensure   => 'present',
    provider => 'chocolatey',
  }


}
