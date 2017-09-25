# Class: profile::windows::activedirectory::organizationalunits
#
#
class profile::windows::activedirectory::organizationalunits(

) {

  dsc_xadorganizationalunit { 'Domain Controllers':
    dsc_ensure      => 'present',
    dsc_name        => 'Domain Controllers',
    dsc_path        => 'DC=tragiccode,DC=local',
    dsc_description => 'Managed by Puppet! Changes made manually may be lost.',
  }
}
