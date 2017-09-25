# Class: profile::windows::activedirectory::groups
#
#
class profile::windows::activedirectory::groups(

) {

  dsc_xadgroup { 'Domain Admins':
    dsc_ensure           => 'present',
    dsc_groupname        => 'Domain Admins',
    dsc_memberstoinclude => ['ad_principal_manager'],
    dsc_category         => 'Security',
    dsc_groupscope       => 'Global',
    dsc_path             => 'CN=Users,DC=tragiccode,DC=local',
    dsc_description      => 'Managed by Puppet! Changes made manually may be lost.',
  }
}
