# Class: role::test
#
#
class role::test {
  # TODO Export a resource with the domain information so that other resources can figure out how to join the domain correctly.
  @@host { $facts['fqdn']:
      #host_aliases =< [],
      ip           => $facts['networking']['ip'],
  }
  Host <<| |>>
}
