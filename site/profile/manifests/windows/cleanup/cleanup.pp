class profile::windows::cleanup::cleanup(

) {

  acl { 'Take Ownership of Windows Temp':
    target => 'C:\\Windows\\Temp',
    owner  => 'Local System',
  }
  # Cleans up temp files for us!  Could also be done using a scheduled task if we don't want it to be cleaned on every run
  tidy { 'Cleanup Windows Temp':
    path    => 'C:\\Windows\\Temp',
    recurse => true,
    matches => [ '*.*' ],
  }
}