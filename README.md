#### Table of Contents

# Introduction
The Goal of this repository is to provide the ability to quickly spin up a puppet enterprise environment for quickly testing changes without having to touch your actual puppet enterprise server.

# Requirements
1.) Install Vagrant

2.) Install Vagrant plugins
```powershell
    > vagrant plugin install vagrant-pe_build
    > vagrant plugin install vagrant-hosts
```
NOTE: If you would like to change/update the version of PE in the vagrant file simply change the version assigned to **config.pe_build.version**


# Using the vagrant plugins
## Listing host names + private ip's
A quick way to list your machines host names and private ip's is to run the following command from the vagrant-hosts plugin that was installed earlier


```powershell
    > vagrant hosts list
```

The following can be run to generate puppet code to update your own machines hosts file to easily communicate with the nodes via their hostnames

```powershell
    > vagrant hosts puppetize | puppet apply
```

# Running puppet commands from the host machine
```powershell
    > vagrant ssh puppetmaster -c "sudo puppet node purge dc-001.attlocal.com"
```

# Rendering epp templates from CLI for verification
```powershell
    > bundle exec puppet epp render ./site/profile/templates/windows/sqlserver/sqlserver/enable-filestream.ps1.epp --values '{ operation => "command", instance_name => "MSSQLSERVER", filestream_access_level => 3 }'
```

# Using Code Manager
1.) Install Pe-Client tools on your local workstation
2.) Run the following to quickly configure PE Client tools
```powershell
    > Configure-PEClientTools.ps1
```
2.) Update your hosts file to have the following entry
```powershell
    10.20.1.2     puppetmaster.local
```
3.) Obtain a RBAC token so you can deploy environments
```powershell
    > puppet-access login --username admin
```
4.) Initiate a deployment of all environments
```powershell
    > puppet-code print-config
    > puppet-code status
    > puppet-code deploy --all --wait --log-level info
```

# Using Eyaml
First you will need to generate some encryption keys.  Simply run the following command

```powershell
    > bundle exec eyaml createkeys
```


The content you want encrypted should live in a file with the .eyaml extension.  It should initially have the unencrypted value wrapped in some markers eyaml expects to find

Example
```
---
password: DEC::PKCS7[my super secret password here]!
```

Next you can encrypt the content of a string utilizing eyaml cli
```powershell
    > bundle exec eyaml encrypt -s 'hello there bob!'
```

```data/secure.eyaml
password: >
    ENC[PKCS7,MIIBiQYJKoZIhvcNAQcDoIIBejCCAXYCAQAxggEhMIIBHQIBADAFMAACAQEw
    DQYJKoZIhvcNAQEBBQAEggEAXjA0MbZ/x+iZOnAyklysIZeYiielyRuukTPL
    CvyqKiWBWMJD3Cu3tC6N2wfjqxZ2sK/yGZqduYqamKfKx5Y7uxu3su7l/FWa
    1eyqXfM/l+KQi2RJTTYjWtg+pg+uUejN9X9tpB6zjp8yjHHTpPaRTix/9tDW
    uyGR+cbLYIXiHXhLNZ5X7CvaiBDbVSQdfkwt4/eCHJuCkrzNZ0C6FlP94610
    mMLAI345hRa/Auiwtxy0qfpKCDIrpBczEqgMZDhnJ/0tLEu4P70Uy7t08A2A
    8I+d/IyRjhoHWfOvuNH3rbwBBoqAFfTLhSb4xd+jMDYWR931PB3V3mKo6c5J
    VpeanDBMBgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBBSoYEAbjrkCBjKEXOc
    x1a/gCCF1KRi3NMVcCErYP0RA6HgTvR51dIFnx67MeDQHNr9oA==]
```

To decrypt the eyaml file and view the contents from the command line run the following
```powershell
    > bundle exec eyaml decrypt -e .\data\secure.eyaml
```

```decrypted output
    ---
password: >
  DEC::PKCS7[hello there bob!]!
```


# Setting up master for hiera-eyaml
First you must install hiera-eyaml on the puppet server.
```powershell
    > sudo /opt/puppetlabs/bin/puppetserver gem install hiera-eyaml
    > service pe-puppetserver reload
```

The restart is needed in order to load this gem into puppetserver for utilization



# Encrypting the contents of a file
You can point eyaml at a file to encrypt all of its contents to be pasted into hiera.  Example
```powershell
    > bundle exec eyaml encrypt -f C:\Windows\System32\drivers\etc\hosts
```

```
hosts_file_content: >
    ENC[PKCS7,MIIFHQYJKoZIhvcNAQcDoIIFDjCCBQoCAQAxggEhMIIBHQIBADAFMAACAQEw
    DQYJKoZIhvcNAQEBBQAEggEAmBDRVh1Ti0SuVjdeeKuvkdAJDKkHSsFTeCqz
    wA53ykA3U3iqramFv0tggVIVmFgENvIkMkC0AtYOAIUvIA0Ez6RqIgVL8mck
    /nf8zrlrpA1He1veibZZkxm+v4nGp5gik6SgP94V8RgK2eJRzf++0N+TJ5bP
    y8mSjLESmAHiEwD9nv1oEEvl6MHGj3obmW3upTFxarz7Y9qSBVoPeIck3OT3
    6T4muadCjcAX568BSCPT4aInkGmOqN48xXPwP5cybnQtAP1CPsDdnA4Qqi8X
    gYOJkeRfW5Zmu9PKDiZ0CDdI1ZQgl0ScGrZegIOvqiOjEWLGI+rMDZBFZfwN
    rsXBhzCCA94GCSqGSIb3DQEHATAdBglghkgBZQMEASoEENLR68D+49dWDXC/
    Yp1B4ZuAggOw1QBd+qSWJ5stG46xGpbKUmgoJaj+YMJlbeaNFfY9eVClnjhN
    nJQirUPXlg0KHgn3rtabXS2LcVnLkd0anRziZROoaPAzkmXfha7t3AHw0C2m
    39H/QodKKopwxggqb42doUa+W650kmA4ZVn7LN3H5BQACSDscdL6ZgNDRbBO
    3hVXp7FuToqCzjSjuQd+U/gbDB2jhTHtA5GB80ZT1OoS7NAWXGwkhN2/t1BM
    LOQmaPul1Kj7G8WaokQiOVL3IByrrVp4CNjdt9v1d4K1r9Gziwnf978FLItT
    JORrE7scGBlsMBQ00hqvzqbKgs73nxiamMB5M/IkgjtrOQjgZpy9a2HrOrXj
    Z4DKAE9shGz0h3opXUVZuMHHvkvSBRb4ta1ZYkROChDCRNza5s7AwhhWiyrn
    CZgu+n9+W2Ft09fJ82yluvZ5KGOehSQ9+i2a3qWDR769ARH768pHNQaAx1NJ
    pVfCf0jZT5zTUpHblUgRrTX0XofDnnu+8fRbkNwHEV2S9gubxI+sApQv5JtH
    XgHYGLiSPxeRG8jo861TkoizOOTcrB+61Me456eHzEIc4CPEO/TRYmaILjYu
    yUB8ctq0Y5yPl9jghwWKu5j9R33cGlLZTBgoGaNojWegZ4FwnBK0hicKu836
    yefYMAzAMcO4ZS9qHwB86fhD0L4Y869dWSWFQHX3Hhh35LGeWk6zpAwcnn8g
    +3KOrsOGV1FeyRLlbDF9ep9Pcs/9jMatYCptg9cLH/rvVkYF45d4ALvgudEu
    H/bwGUCDh1V1S5C5etueIoCXZr1gZqQrwWAaYg43YKf1MCj5IHFmgwtr5Tml
    tv2Vt9hh0+Nyj0J7+gzjcx6iDrOd9Lcy3elnVQl6AAD5jUYKVzxs4wqXHHmH
    bNwiNE6dvY1JLjz4SccD0paCcBFT/5q56yGyOaqJDMNYVYX+KM1SKPcvjwR7
    HHAavI4a9t05VH0/stiGeDS77ZMutXQA17xpAy0JAjKj5ay8WhLr8ds7aXtp
    8rfTf8sVONtK7BmgwuyHHrk7bj9hEx8O96L3QqHRK0lvRtr9xQ5pdSQ9ggp7
    8JBKLkOYjACIFskQhXP2gmEpIvqGKWVNVOAXgS116rMVxZwj/9iz84Nvoi6k
    6gtOimkiCo5QzV9JiaUI3+ppXi/qL454LiEy9iSNSKbPOVFjROZH/7H/oQE4
    7yjjkiED7kWN4NQ052Q+ncpcIT+HngnQ+WN4Lx9VPEcUA4lGWYpIkZd1+rMn
    Ee1h5kT3aV0=]
```

# Encrypting a password
If you don't want the password to be visible from your screen as you encrypt something use the following ot be prompted for the password
```powershell
    > bundle exec eyaml encrypt -p
```

# label
By default when you encrypt something the hiera key is called 'block' to auto create the label so it's a straight copy and paste from stdout to hiera do the following
```powershell
    > bundle exec eyaml encrypt -l 'some_easy_to_use_label' -s 'yourSecretString'
```

```
some_easy_to_use_label: >
    ENC[PKCS7,MIIBiQYJKoZIhvcNAQcDoIIBejCCAXYCAQAxggEhMIIBHQIBADAFMAACAQEw
    DQYJKoZIhvcNAQEBBQAEggEAmdDNxHOjsajuh0KXJFiEh1OuPq3HvIhaoDfx
    28sNWf/3Gy0fzSmbciKUqrpEneZtB7pBs9G7hXIqr+vpcG0uj6wmme5ioA2r
    oIe2CZZeapXCdi6+zghABYA8Vtx/B/ZhEzFEHBMV28ipAl45EB2wimR9M8dH
    L6Das7BjmOMOXwEu9MIubs6QmzXE0dNHxPa1ldDPT4+nzCjLcSLj88c0M2uK
    pRU9IZQjcXor3cbrkEzoJZcMUxXXM/UPlXgtu1OmhlcTK3yvxoWkFBoTLgyL
    k/tXSteG0boeOaHkJ3UOzfcWGWLVHZ/+FCuw3FK+34mgLi4IpyAzvn4KJEkR
    U0/ptTBMBgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBB/imFWp4D9XOu6T50u
    9Z/4gCB8t4dl5bFy/OEDxKMRf6eCTFh77DfhdamKWvEK94l52g==]
```

# TODO: Hook up vault hiera backend
https://github.com/jsok/hiera-vault

# Connecting to vault
```powershell
> $env:VAULT_ADDR = 'http://10.20.1.13:8200'
> vault.exe write secret/hello key=world
```

# How can I avoid download fixtures dependencies every time I run `bundle exec rake spec`?
```powershell
    > bundle exec rake spec_prep
    > bundle exec rake spec_standalone
```


# Testing hiera lookup on your local developerbox
```powershell
  > bundle exec puppet lookup --hiera_config .\hiera.yaml 'profile::domainbase::domain_name'
```

# Graphite
http://10.20.1.12


# Grafana
http://10.20.1.12:3000
1.) Create datasource that points the local graphite server to pull in puppetserver stats

Url : http://localhost
Access : proxy

# Query puppetdb from inside manifest
Puppet enterprise provides a function that is already ready to be used to query puppetdb and pull data out from within a manifest

```powershell
  $windows_nodes_query = 'nodes[certname]{facts{name = "operatingsystem" and value = "windows"}}'
  $windows_nodes = puppetdb_query($windows_nodes_query).each |$value| { $value["certname"] }
  notify {'windows nodes':
      message => "Your windows nodes are ${join($windows_nodes, ', ')}",
  }
  ```

  NOTE: I didn't any any modules or configure anything.  This worked straight up out of the box for puppet enterprise 2017.2.2


  # Pry Debugging
  To start debugging just put a breakpoint anywhere in your ruby code where you want to stop execution at
  ```
    require 'pry'; binding.pry
  ```

  It's easy to get lost or forget where you are @ in the code so to let pry tell you you can run the following command
```
    > whereami
```

View the stack
```
    > show-stack
```

Stepping through the code
Move to next line
```
    > next
```

step into a function
```
    > step
```

Continue execution
If you want to continue execution to the end of the program or to next available breakpoiont simply run the following command
```
    > continue
```


Completely exit out of the debugger and program
```
    > exit!
```


# Quick way to get into a IRB console
A quick way to get into an IRB console to play around with ruby code is to use pry by executing the following
```
    > bundle exec pry
```


# Upload local files to the guest vm via vagrant winrm
```
> vagrant winrm-upload 'C:\vox\puppet-windowsfeature' 'C:\ProgramData\Puppetlabs\code\modules' dc-001
```

# Possible Issues with vagrant
https://github.com/hashicorp/vagrant/issues/8785

# MCollective Useful Commands

## Disable/Enable Agents
```powershell
> mco rpc puppet disable message="testing disable - mfyffe" --with-identity mytestnode.local
```

```powershell
> mco rpc puppet enable --with-identity mytestnode.local
```

## Puppet Best Practices

https://github.com/puppetlabs/best-practices



## Deployment Information

## Development

Develop on the master branch using a feature-branch workflow.  Commits merged into master will be automatically tested, promoted, and deployed to each successive environment tier by the CI/CD System.

NOTE: Each branch of this repository represents a deployable and testable puppet environment

In order to deploy a given branch as a puppet environment, run:

```
puppet code deploy $branch --wait
```

After the puppet environment is deployed, you can test a puppet agent against that branch by:

```
puppet agent -t --environment $branch
```

NOTE: this strategy is just a commit and hand of to CI/CD Server to merge it through to all the other puppet environments.
NOTE: Just like "Continuous Deliver for PE" it's important to understand what you should do in git and what git work "CD for PE" wil handle for you.  https://puppet.com/docs/continuous-delivery/1.x/setting_up.html#concept-1698

## How to use large files in your profile module

For large files you want to use in your profiles you don't want them in your repository ( git doesn't handle large binaries well ).  Instead you should upload the files to S3, take a checksum of the files ( shown in S3 when you upload them ), put it in the following s3 bucket path:

for example:
s3.amazon.aws.com/webops/puppet_files/$profilename/largefile.iso

in your files directory create a staging.yaml with the content of:

```
---
largefile.iso: 'md5sum_of_file'
evenlargerfile.iso: 'md5sum_of_file'
```

The masters will then have a class applied to him called 'puppet_files' which will reference these and stage them at a predictable URLs for you:

puppet:///puppet_files/$profilename/largefile.iso
http://$master/puppet_files/$profilename/largefile.iso
smb://$master/puppet_files/$profilename/largefile.iso

You can then use remote_file, the built in puppet file resource to retrieve the files or use the "attach_master" on windows to attach the smb share as the Z drive / unc path on your machines to reference them later.

The above stuff needs more information but essentially you can download remote files from s3 onto the master into a specific file location like so

```
class profile::master::files::jdk (
  $srv_root = '/opt/tse-files',
) {
  file { "${srv_root}/jdk":
    ensure => directory,
    mode   => '0755',
  }

  remote_file { 'jdk-8u45-windows-x64.exe':
    source  => 'https://s3-us-west-2.amazonaws.com/tseteam/files/jdk-8u45-windows-x64.exe',
    path    => "${srv_root}/jdk/jdk-8u45-windows-x64.exe",
    headers => {
      'user-agent' => 'Mozilla/5.0 (Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko',
      'Cookie'     => 'oraclelicense=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com'
    }, # Oracle makes you accept the license agreement -_-
    mode    => '0644',
    require => File["${srv_root}/jdk"],
  }
}
```

Then you could, for example, setup a http file server on your puppet master
```
class profile::master::fileserver {
  include 'stdlib'
  include 'profile::firewall'
  include 'profile::apache'

  # Detect Vagrant
  case $::virtual {
    'virtualbox': {
      $admin_file_owner = 'vagrant'
      $admin_file_group = 'vagrant'
    }
    default: {
      $admin_file_owner = 'root'
      $admin_file_group = 'root'
    }
  }

  apache::vhost { 'tse-files':
    vhost_name    => '*',
    port          => '81',
    docroot       => '/opt/tse-files',
    priority      => '10',
    docroot_owner => $admin_file_owner,
    docroot_group => $admin_file_group,
  }

  firewall { '110 apache allow all':
    dport  => '81',
    chain  => 'INPUT',
    proto  => 'tcp',
    action => 'accept',
  }

  # The *::finalize class includes some configuration that should be applied
  # after everything is up and fully operational. Some of this configuration is
  # used to signal to external watchers that the master is fully configured and
  # ready.
  class { 'profile::master::fileserver::finalize':
    stage => 'deploy_app',
  }

}
```

now we can download files on windows from the puppetmaster.  Not sure about smb.


## Rolling our own Jenkins deployment pipeline
Lets talk about a couple of ways we can do a phased deployment of our puppet code promoting it from 1 environment to the next
using a jenkins pipeline.

================

1. branch/puppet environment per environment that you have ( development, staging, and production )

pros
------
- true code seperation between environments
- Safety net in which if the code pass dev environment and got promoted to staging and something bad happened and you killed the pipeline you can have peace of mind if someone goes in and does a puppet agent run on all nodes in all environments you wont have a production outage or really bad things happen.

cons
------
- rolling back requires a change to go out so that someone later doesn't force run puppet causing cached catalogs to not be used or no-noop to happen
- Long lived branches that you have to manage or get some other thing like jenkins to manage the merging for you.  I assume if you merge to dev and it blows up in production then you just make the fix and make your way through the pipeline again.  The long live branches will differ in commits because of this but the code will eventually be the same when you make it through the pipeline successfully.
- since our aim is to control the push out of puppet changes we will need to do one of the following to prevent uncontrolled puppet runs with the new code
    1. Cached-Catalogs on agents

    ```
        ini_setting { 'puppet agent use_cached_catalog':
        ensure  => $ensure_setting,
        path    => $puppet_conf,
        section => 'agent',
        setting => 'use_cached_catalog',
        # lint:ignore:quoted_booleans
        value   => 'true',
        # lint:endignore
    }
    ```
    
    2. noop mode

    ```
        ini_setting { 'puppet agent use_cached_catalog':
        ensure  => $ensure_setting,
        path    => $puppet_conf,
        section => 'agent',
        setting => 'noop',
        # lint:ignore:quoted_booleans
        value   => 'true',
        # lint:endignore
    }
    ```

  3. You can even use a combination of both to keep track of changes instead of autocorrect


================

2. 1 branch/puppet environment used for all nodes and you simply use a fact ( trusted.extensions.pp_environment = "production" ) to control deployments to nodes

pros
------
- No long-lived branches.  Simply have 1 master/production branch

cons
------
- rolling back requires a change to go out so that someone later doesn't force run puppet causing cached catalogs to not be used or no-noop to happen
- Because there is no code seperation via long lived branches if someone makes it partially through the pipeline and someone comes in later and does a puppet job on all
  nodes in all environemnts it could cause an outage!
- since our aim is to control the push out of puppet changes we will need to do one of the following to prevent uncontrolled puppet runs with the new code
    1. Cached-Catalogs on agents

    ```
    ini_setting { 'puppet agent use_cached_catalog':
        ensure  => $ensure_setting,
        path    => $puppet_conf,
        section => 'agent',
        setting => 'use_cached_catalog',
        # lint:ignore:quoted_booleans
        value   => 'true',
        # lint:endignore
    }
    ```
    
    2. noop mode

    ```
    ini_setting { 'puppet agent use_cached_catalog':
        ensure  => $ensure_setting,
        path    => $puppet_conf,
        section => 'agent',
        setting => 'noop',
        # lint:ignore:quoted_booleans
        value   => 'true',
        # lint:endignore
    }
    ```

  3. You can even use a combination of both to keep track of changes instead of autocorrect



  ================

  3. Something simliar to cd4pe and
    - Create a temp branch with the change
    - push temp branch
    - perform code deploy
    - create a child group to you target deployment environment that overrides the environment to use your temp branch and pin desired nodes to group
    - perform a puppet job run on the temp environment
    - if puppet run fails delete child group and branch and exist pipeline
    - if puppet run succeeds delete child group and merge changes into target environment's long lived branch. 


==========================
This is a type of workflow using cached catalogs on agents
    https://puppet.com/docs/pe/2018.1/direct_puppet_a_workflow_for_controlling_change.html



Direct Deployment workflow ( this currently deploys to all nodes )
---------------------------
This policy is used when you want to release changes that you are making a small change you now will not cause any issues

In Short it says i want to go ahead and promote a change and run it to ALL nodes in a given environment right now!

1. Create all branches before hand that you want
1. Pick a commit to deploy to an environment.
1. cd4pe will go a git reset or git update-ref.  no sure which one and push to github.
1. cd4pe then does a code manager deploy so pe essentially checkouts this updated branch
1. cd4pe then calls out to orchestrator to kick of puppet runs on all nodes in this update environment.  It's a depoy all!



Temporary Branch Deployment ( reduce your blast radius so the deployment isn't this big bang )
-----------------------------
It's the same as direct deployment in that you are promoting a change to an entire environment except instead of updating the branch that represent the target environment you want to deploy the change to.
it creates a new git branch creating a new environment for this deployment ( production_cdpe_102 ).  It will then createa  child environment group of the target environment and assign this environment to it add all the nodes
in the target environment.  What does this give you that you don't get in the "Direct Deployment"?  You don't get rolling deployments to slowly roll out a new change. For Example deploy to 2 nodes at a time

1. Create all branch beforehand that you want
1. Pick a commit to deploy to an environment
1. Pick how you want to do a rolling deployment:
    - Deploy to 2 nodes at a time
1. cd4pe will create a new branch off your target environment ( production_cdpe_102 ) and will git reset or git update-ref the commit you want to deploy to this environment
1. cd4pe then does a code manager deploy so pe essentially checkouts this updated branch
1. cd4pe will create a child environment group for production_cdpe_102 and pin 2 nodes to it.
1. cd4pe will trigger an orchestration job on these 2 nodes
1. cd4pe will grab 2 more nodes and so on and so on.
1. cd4pe will delete the temp branch and the temp environment group once all nodes have been applied the change
1. cd4pe will then update the target branch to the commit you jsut deployed

If you configure it to abort the deployment if any nodes have failures with this policy it will cleanup the branch and node group and never advance the target branch on the commit that didnt work unlike direct deployment policy

NOTE: As soon as you pick "temp branch policy" you get a new option you can configured to stagger the rolling deployment because well that is what this is!  Its mandatory and examples are below

Stagger Settings:
    Deploy 10 nodes at a time with a 60 second delay

Production Environment - production
    - Production Environment Rolling Deployment 22 - production_cd4pe_22


Incremental Branch Deployment
-------------------------------
This works almost identical to the temp branch policy except the temp branches hang around forever for history purposes if you need them.  The idea here is you can go back and look at git to see deployment history in git.

Same as above except instead of deleting the branch it leaves it around and points your target environment to this incremental branch! the target branch is no longer being used and is kind of just there for history!

NOTE: You still get the SAME settings as temp branch deployment.  The stagger settings so this is still a rolling deployment

Blue Green Deployment
------------------------------
Its similiar to incremetnal branch in that it creates 2 branches blue and green and only maintains and keeps 2 and they constantly move.  The idea here is that as you do deployments you always have a safe version of code available and you can revert to it easily without having all the branches in git like the incremental branch strategy

1. Same as temp branch deployment.  it creates a child group for blue or green.  once it all passes it deletes the temp group and assigns a new environment to the target environment and makes it blue or green respectively

NOTE: This one is also a rolling deployment!