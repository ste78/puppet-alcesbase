################################################################################
##
## Alces HPC Software Stack - Puppet configuration files
## Copyright (c) 2008-2013 Alces Software Ltd
##
################################################################################
class alcesbase::profile::service (
  $role,
) inherits ::alcesbase::profile
{
  $profile='service'
  class { 'alcesbase':
          role=>$role,
          profile=>$profile,
	  stage=>init,
        }
  class { 'alcesbase::install':
          stage=>install,
        }
  class { 'alcesnetwork':
          role=>$role,
          profile=>$profile,
          stage=>install,
          destructive=>$reinstall,
  }
  class { 'alcesbase::config':
          stage=>configure,
  }
  class { 'alcesservices':
           role=>$role,
           profile=>$profile,
	   stage=>configure,
  }
  class { 'alcesmonitoring':
                role=>$role,
                profile=>$profile,
                machine=>$alces_machine,
                stage=>configure,
  }
}
