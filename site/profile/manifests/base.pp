class profile::base {

  # Include a platform-appropriate base profile
  # profile::base must be assigned to every machine, including workstations. 
  # It manages basic policies, and uses some conditional logic to include OS-specific profiles as needed.
  case $facts['kernel'] {
    'Linux':   { include profile::linux::base   }
    'windows': { include profile::windows::base }
    default:   { }
  }

}
