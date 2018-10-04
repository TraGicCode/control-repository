# Class: profile::windows::base
#
#
class profile::windows::base {
  # include profile::firewall
  # include profile::defender

  # Lock users startup folder by changing permissions to prevent them from changing this
  # this prevents hackers/maliciuous software from executing code on startup

  # Lock the host file to prevent malicious software from redirecting the user to a fake website
  # Maybe permissions is fine for this?

  # Stop unnessary services we don't use to reduce attack surface
  # Stop rdp
  # stop smb
  # Stop network places discovery

  # start necessary services
  # start antivirus if installed

  class { 'chocolatey':
    chocolatey_version => '0.10.6.1',
    log_output         => true,
  }

  chocolateyconfig { 'cacheLocation':
    ensure => 'present',
    value  => 'C:\\ProgramData\\choco-cache',
  }

  chocolateyconfig { 'commandExecutionTimeoutSeconds':
    ensure => 'present',
    value  => '2700',
  }

  chocolateyfeature { 'allowemptychecksums':
    ensure => 'disabled',
  }
  chocolateyfeature { 'allowemptychecksumssecure':
    ensure => 'enabled',
  }
  chocolateyfeature { 'allowglobalconfirmation':
    ensure => 'disabled',
  }
  chocolateyfeature { 'autouninstaller':
    ensure => 'enabled',
  }
  chocolateyfeature { 'checksumfiles':
    ensure => 'enabled',
  }
  chocolateyfeature { 'failonautouninstaller':
    ensure => 'disabled',
  }
  chocolateyfeature { 'failoninvalidormissinglicense':
    ensure => 'disabled',
  }
  chocolateyfeature { 'failonstandarderror':
    ensure => 'disabled',
  }
  chocolateyfeature { 'ignoreinvalidoptionsswitches':
    ensure => 'enabled',
  }
  chocolateyfeature { 'ignoreunfoundpackagesonupgradeoutdated':
    ensure => 'disabled',
  }
  chocolateyfeature { 'logenvironmentvalues':
    ensure => 'disabled',
  }
  chocolateyfeature { 'logwithoutcolor':
    ensure => 'disabled',
  }
  chocolateyfeature { 'powershellhost':
    ensure => 'enabled',
  }
  chocolateyfeature { 'removepackageinformationonuninstall':
    ensure => 'disabled',
  }
  chocolateyfeature { 'scriptschecklastexitcode':
    ensure => 'disabled',
  }
  chocolateyfeature { 'showdownloadprogress':
    ensure => 'enabled',
  }
  chocolateyfeature { 'shownonelevatedwarnings':
    ensure => 'enabled',
  }
  chocolateyfeature { 'stoponfirstpackagefailure':
    ensure => 'disabled',
  }
  chocolateyfeature { 'usefipscompliantchecksums':
    ensure => 'disabled',
  }
  chocolateyfeature { 'usepackageexitcodes':
    ensure => 'enabled',
  }
  chocolateyfeature { 'userememberedargumentsforupgrades':
    ensure => 'disabled',
  }
  chocolateyfeature { 'viruscheck':
    ensure => 'disabled',
  }

  dsc_xtimezone { 'Server Timezone':
    ensure               => 'present',
    dsc_issingleinstance => 'yes',
    dsc_timezone         => 'UTC',
  }

}
