class storm(
  $command                 = $storm::params::command,
  $config                  = $storm::params::config,
  $config_template         = $storm::params::config_template,
  $gid                     = $storm::params::gid,
  $group                   = $storm::params::group,
  $group_ensure            = $storm::params::group_ensure,
  $local_dir               = $storm::params::local_dir,
  $local_hostname          = $storm::params::local_hostname,
  $log_dir                 = $storm::params::log_dir,
  $nimbus_host             = $storm::params::nimbus_host,
  $nimbus_childopts        = $storm::params::nimbus_childopts,
  $package_name            = $storm::params::package_name,
  $package_ensure          = $storm::params::package_ensure,
  $service_autorestart     = hiera('storm::service_autorestart', $storm::params::service_autorestart),
  $service_enable          = hiera('storm::service_enable', $storm::params::service_enable),
  $service_ensure          = $storm::params::service_ensure,
  $service_manage          = hiera('storm::service_manage', $storm::params::service_manage),
  $service_name_nimbus     = $storm::params::service_name_nimbus,
  $service_name_supervisor = $storm::params::service_name_supervisor,
  $service_name_ui         = $storm::params::service_name_ui,
  $service_retries         = $storm::params::service_retries,
  $service_startsecs       = $storm::params::service_startsecs,
  $service_stderr_logfile_keep    = $storm::params::service_stderr_logfile_keep,
  $service_stderr_logfile_maxsize = $storm::params::service_stderr_logfile_maxsize,
  $service_stdout_logfile_keep    = $storm::params::service_stdout_logfile_keep,
  $service_stdout_logfile_maxsize = $storm::params::service_stdout_logfile_maxsize,
  $shell                   = $storm::params::shell,
  $storm_messaging_transport      = $storm::params::storm_messaging_transport,
  $supervisor_childopts    = $storm::params::supervisor_childopts,
  $supervisor_slots_ports  = $storm::params::supervisor_slots_ports,
  $ui_childopts            = $storm::params::ui_childopts,
  $uid                     = $storm::params::uid,
  $user                    = $storm::params::user,
  $user_description        = $storm::params::user_description,
  $user_ensure             = $storm::params::user_ensure,
  $user_home               = $storm::params::user_home,
  $user_managehome         = hiera('storm::user_managehome', $storm::params::user_managehome),
  $worker_childopts        = $storm::params::worker_childopts,
  $zookeeper_servers       = $storm::params::zookeeper_servers,
) inherits storm::params {

  validate_string($command)
  validate_absolute_path($config)
  validate_string($config_template)
  if !is_integer($gid) { fail('The $gid parameter must be an integer number') }
  validate_string($group)
  validate_string($group_ensure)
  validate_absolute_path($local_dir)
  validate_string($local_hostname)
  validate_absolute_path($log_dir)
  validate_string($nimbus_host)
  validate_string($nimbus_childopts)
  validate_string($package_name)
  validate_string($package_ensure)
  validate_bool($service_autorestart)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_string($service_name_nimbus)
  validate_string($service_name_supervisor)
  validate_string($service_name_ui)
  if !is_integer($service_retries) { fail('The $service_retries parameter must be an integer number') }
  if !is_integer($service_startsecs) { fail('The $service_startsecs parameter must be an integer number') }
  if !is_integer($service_stderr_logfile_keep) {
    fail('The $service_stderr_logfile_keep parameter must be an integer number')
  }
  validate_string($service_stderr_logfile_maxsize)
  if !is_integer($service_stdout_logfile_keep) {
    fail('The $service_stdout_logfile_keep parameter must be an integer number')
  }
  validate_string($service_stdout_logfile_maxsize)
  validate_absolute_path($shell)
  validate_string($storm_messaging_transport)
  validate_string($supervisor_childopts)
  validate_array($supervisor_slots_ports)
  validate_string($ui_childopts)
  if !is_integer($uid) { fail('The $uid parameter must be an integer number') }
  validate_string($user)
  validate_string($user_description)
  validate_string($user_ensure)
  validate_absolute_path($user_home)
  validate_bool($user_managehome)
  validate_string($worker_childopts)
  validate_array($zookeeper_servers)

  include '::storm::install'
  include '::storm::config'

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up. You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'storm::begin': }
  anchor { 'storm::end': }

  Anchor['storm::begin'] -> Class['::storm::install'] -> Class['::storm::config'] -> Anchor['storm::end']
}
