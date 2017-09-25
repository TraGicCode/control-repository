# Class: profile::domaincontrollertest_again
#
#
class profile::domaincontrollertest_again(
    String $some_parameter,
    String $domain_name,
) {

    notify { "${domain_name} - ${some_parameter}": }
}