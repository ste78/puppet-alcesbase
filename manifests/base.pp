################################################################################
##
## Alces HPC Software Stack - Puppet configuration files
## Copyright (c) 2008-2013 Alces Software Ltd
##
################################################################################
class alcesbase::base (
  $nvidia=false,
  $jitter=$alcesbase::jitter,
  $serialconsoledevice=undef,
  $serialconsolebaud=undef,
)
{

  package { 'augeas':
    ensure=>installed,
  }

  file {'/etc/modprobe.d/alces-blacklist.conf':
    ensure=>present,
    owner=>'root',
    group=>'root',
    content=>template('alcesbase/alces-blacklist.conf.erb')
  }

  augeas {'sysconfig-selinux-disabled':
    context => "/files/etc/sysconfig/selinux",
    changes => "set SELINUX disabled",
  }

  package {'yum-plugin-priorities':
    ensure=>installed,
  }
  
  augeas {'disable-yumautoupdate':
    context => "/files/etc/sysconfig/yum-autoupdate",
    changes => "set ENABLED false",
    onlyif => "match ENABLED size > 0",
  }

  package {'ipmitool':
    ensure=>installed,
  }
  #IPMI service
  if $jitter {
    if ! str2bool($is_virtual) {
      package { "OpenIPMI":
        ensure=>'installed'
      }
      service { 'ipmi':
        enable=>true,
        ensure=>running
      }
    }
  }

  package {'pdsh':
    ensure=>installed,
  }
  package {'pdsh-rcmd-ssh':
    ensure=>installed,
  }
  package {'pdsh-mod-genders':
    ensure=>installed,
  }
  package {'genders':
    ensure=>installed,
  }
  package {'genders-compat':
    ensure=>installed,
  }

  #PDSH
  file {'/etc/genders':
      mode=>0644,
      owner=>'root',
      group=>'root',
      ensure=>present,
      content=>template('alcesbase/genders.erb'),
      require=>Package['pdsh-mod-genders']
  }

  #Serial console
  if ($serialconsoledevice) and ($serialconsolebaud) {
    $serialconsole_device=$serialconsoledevice
    $serialconsole_baud=$serialconsolebaud
    file {'/etc/init/alces_serial.conf':
      ensure=>present,
      mode=>0644,
      owner=>'root',
      group=>'root',
      content=>template('alcesservices/alces_serial.erb')
    }
  } 
}
