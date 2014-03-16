class storm::params {
  $command                 = '/opt/storm/bin/storm'
  $config                  = '/opt/storm/conf/storm.yaml'
  $config_template         = 'storm/storm.yaml.erb'
  $gid                     = 53001
  $group                   = 'storm'
  $group_ensure            = 'present'
  $local_dir               = '/app/storm'
  $local_hostname          = $::hostname
  $log_dir                 = '/var/log/storm'
  $logback                 = '/opt/storm/logback/cluster.xml'
  $logback_template        = 'storm/cluster.xml.erb'
  $nimbus_host             = 'nimbus1'
  $nimbus_childopts        = '-Xmx256m -Djava.net.preferIPv4Stack=true'
  $package_name            = 'storm'
  $package_ensure          = 'present'
  $service_autorestart     = true
  $service_enable          = true
  $service_ensure          = 'present'
  $service_manage          = true
  $service_name_nimbus     = 'storm-nimbus'
  $service_name_supervisor = 'storm-supervisor'
  $service_name_ui         = 'storm-ui'
  $service_retries         = 999
  $service_startsecs       = 10
  $service_stderr_logfile_keep    = 10
  $service_stderr_logfile_maxsize = '20MB'
  $service_stdout_logfile_keep    = 5
  $service_stdout_logfile_maxsize = '20MB'
  $shell                   = '/bin/bash'
  $storm_messaging_transport      = 'backtype.storm.messaging.netty.Context'
  $supervisor_childopts    = '-Xmx256m -Djava.net.preferIPv4Stack=true'
  $supervisor_slots_ports  = [6700, 6701]
  $ui_childopts            = '-Xmx256m -Djava.net.preferIPv4Stack=true'
  $uid                     = 53001
  $user                    = 'storm'
  $user_description        = 'Storm system account'
  $user_ensure             = 'present'
  $user_home               = '/home/storm'
  $user_managehome         = true
  $worker_childopts        = '-Xmx256m -Djava.net.preferIPv4Stack=true'
  $zookeeper_servers       = ['zookeeper1']

  # Parameters not exposed to the user via init.pp
  $storm_rpm_log_dir       = '/opt/storm/logs' # Must match RPM layout; use $log_dir to define actual logging directory
  validate_absolute_path($storm_rpm_log_dir)

  case $::osfamily {
    'RedHat': {}

    default: {
      fail("The ${module_name} module is not supported on a ${::osfamily} based system.")
    }
  }
}
