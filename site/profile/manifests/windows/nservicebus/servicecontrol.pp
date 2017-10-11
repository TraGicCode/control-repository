# Class: profile::windows::nservicebus::servicecontrol
#
#
class profile::windows::nservicebus::servicecontrol {
    class { 'nservicebusservicecontrol':
        package_ensure                     => 'present',
        file_source                        => 'https://storage.googleapis.com/puppet-provisioning-binaries/NServiceBus%20ServiceControl/Latest/Particular.ServiceControl-1.41.3.exe',
        file_path                          => 'C:\\Particular.ServiceControl-1.41.3.exe',
        package_name                       => 'Particular Software ServiceControl Management',
        package_install_options_log_path   => 'C:\\Particular.ServiceControl.install.log',
        package_uninstall_options_log_path => 'C:\\Particular.ServiceControl.uninstall.log',
        # license_xml                        => Sensitive(''),
    }
}
