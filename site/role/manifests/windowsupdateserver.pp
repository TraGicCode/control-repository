# Class: role::windowsupdateserver
#
#
class role::windowsupdateserver {
  include profile::base
  include profile::windows::windowsupdateserver

    Class['profile::base']
    -> Class['profile::windows::windowsupdateserver']
}
