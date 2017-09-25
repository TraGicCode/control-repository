class role::domaincontroller {

  #This role would be made of all the profiles that need to be included to make a domaincontroller work
  #All roles should include the base profile
  include profile::base
  include profile::windows::activedirectory::domaincontroller
  include profile::windows::activedirectory::dnsserver
  include profile::windows::activedirectory::users
  include profile::windows::activedirectory::organizationalunits
  include profile::windows::activedirectory::groups
  include profile::windows::splunk::universalforwarder

  Class['profile::windows::activedirectory::domaincontroller']
  -> Class['profile::windows::activedirectory::dnsserver']
  -> Class['profile::windows::activedirectory::users']
  -> Class['profile::windows::activedirectory::organizationalunits']
  -> Class['profile::windows::activedirectory::groups']
  -> Class['profile::windows::splunk::universalforwarder']
}
