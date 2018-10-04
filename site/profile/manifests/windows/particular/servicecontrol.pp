# Class: profile::windows::particular::servicecontrol
#
#
class profile::windows::particular::servicecontrol {
  class { 'nservicebusservicecontrol':
      package_ensure     => 'present',
      remote_file_source => 'https://storage.googleapis.com/puppet-provisioning-binaries/NServiceBus%20ServiceControl/Latest/Particular.ServiceControl-1.41.3.exe',
      remote_file_path   => 'C:\\Particular.ServiceControl-1.41.3.exe',
      # license_xml                      => Sensitive(''),
  }

  nservicebusservicecontrol::instance { 'Particular.ServiceControl.Development':
    ensure => 'present',
  }
}
