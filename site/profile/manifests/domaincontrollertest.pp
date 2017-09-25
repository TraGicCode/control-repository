# Class: profile::domaincontrollertest
#
#
class profile::domaincontrollertest(
    String $some_parameter,
    String $domain_name = $profile::domainbase::domain_name,
) inherits profile::domainbase {
    # /Stage[main]/Profile::Domaincontrollertest/Notify[gccthd.com - this is a random value]/message
    notify { "${domain_name} - ${some_parameter}": }
}