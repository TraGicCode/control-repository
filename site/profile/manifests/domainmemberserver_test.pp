class profile::domainmemberserver_test (
  String $some_parameter_again,
  String $domain_name = $profile::domainbase::domain_name,
) inherits profile::domainbase {

  notify { "${domain_name} - ${some_parameter_again}": }
}