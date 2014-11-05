# == Class storm wrapper
#
# === Parameters
#
# [*config_map*]
#   Use this parameter for all other Storm related config options except those that are already exposed as class
#   parameters (e.g. `$nimbus_host`, `$local_dir`, `$local_hostname`, `$worker_childopts`).
#
class storm::wrapper(
  $command                        = $storm::params::command,
  $config                         = $storm::params::config,
  $config_map                     = $storm::params::config_map,
  $config_template                = $storm::params::config_template,
  $drpc_childopts                 = $storm::params::drpc_childopts,
  $drpc_servers                   = $storm::params::drpc_servers,
  $enable_drpc                    = $storm::params::enable_drpc,
  $enable_logviewer               = $storm::params::enable_logviewer,
  $enable_nimbus                  = $storm::params::enable_nimbus,
  $enable_supervisor              = $storm::params::enable_supervisor,
  $enable_ui                      = $storm::params::enable_ui,
  $gid                            = $storm::params::gid,
  $group                          = $storm::params::group,
  $group_ensure                   = $storm::params::group_ensure,
  $local_dir                      = $storm::params::local_dir,
  $local_hostname                 = $storm::params::local_hostname,
  $log_dir                        = $storm::params::log_dir,
  $logback                        = $storm::params::logback,
  $logback_template               = $storm::params::logback_template,
  $logviewer_childopts            = $storm::params::logviewer_childopts,
  $nimbus_host                    = $storm::params::nimbus_host,
  $nimbus_childopts               = $storm::params::nimbus_childopts,
  $package_name                   = $storm::params::package_name,
  $package_ensure                 = $storm::params::package_ensure,
  $service_autorestart            = hiera('storm::service_autorestart', $storm::params::service_autorestart),
  $service_enable                 = hiera('storm::service_enable', $storm::params::service_enable),
  $service_ensure                 = $storm::params::service_ensure,
  $service_environment            = '',
  $service_manage                 = hiera('storm::service_manage', $storm::params::service_manage),
  $service_name_drpc              = $storm::params::service_name_drpc,
  $service_name_logviewer         = $storm::params::service_name_logviewer,
  $service_name_nimbus            = $storm::params::service_name_nimbus,
  $service_name_supervisor        = $storm::params::service_name_supervisor,
  $service_name_ui                = $storm::params::service_name_ui,
  $service_retries                = $storm::params::service_retries,
  $service_startsecs              = $storm::params::service_startsecs,
  $service_stderr_logfile_keep    = $storm::params::service_stderr_logfile_keep,
  $service_stderr_logfile_maxsize = $storm::params::service_stderr_logfile_maxsize,
  $service_stdout_logfile_keep    = $storm::params::service_stdout_logfile_keep,
  $service_stdout_logfile_maxsize = $storm::params::service_stdout_logfile_maxsize,
  $shell                          = $storm::params::shell,
  $storm_messaging_transport      = $storm::params::storm_messaging_transport,
  $supervisor_childopts           = $storm::params::supervisor_childopts,
  $supervisor_slots_ports         = $storm::params::supervisor_slots_ports,
  $ui_childopts                   = $storm::params::ui_childopts,
  $uid                            = $storm::params::uid,
  $user                           = $storm::params::user,
  $user_description               = $storm::params::user_description,
  $user_ensure                    = $storm::params::user_ensure,
  $user_home                      = $storm::params::user_home,
  $user_manage                    = hiera('storm::user_manage', $storm::params::user_manage),
  $user_managehome                = hiera('storm::user_managehome', $storm::params::user_managehome),
  $worker_childopts               = $storm::params::worker_childopts,
  $zookeeper_servers              = $storm::params::zookeeper_servers,
) inherits storm::params {

class { 'storm':
  config                         => $config,                        
  config_map                     => $config_map,                   
  config_template                => $config_template,               
  drpc_childopts                 => $drpc_childopts,                
  drpc_servers                   => $drpc_servers,                  
  gid                            => $gid,                           
  group                          => $group,                         
  group_ensure                   => $group_ensure,                  
  local_dir                      => $local_dir,                     
  local_hostname                 => $local_hostname,                
  log_dir                        => $log_dir,                       
  logback                        => $logback,                       
  logback_template               => $logback_template,              
  logviewer_childopts            => $logviewer_childopts,           
  nimbus_host                    => $nimbus_host,                   
  nimbus_childopts               => $nimbus_childopts,              
  package_name                   => $package_name,                  
  package_ensure                 => $package_ensure,                
  service_autorestart            => $service_autorestart,           
  service_enable                 => $service_enable,                
  service_ensure                 => $service_ensure,                
  service_manage                 => $service_manage,                
  service_name_drpc              => $service_name_drpc,             
  service_name_logviewer         => $service_name_logviewer,        
  service_name_nimbus            => $service_name_nimbus,           
  service_name_supervisor        => $service_name_supervisor,      
  service_name_ui                => $service_name_ui,               
  service_retries                => $service_retries,               
  service_startsecs              => $service_startsecs,             
  service_stderr_logfile_keep    => $service_stderr_logfile_keep,   
  service_stderr_logfile_maxsize => $service_stderr_logfile_maxsize,
  service_stdout_logfile_keep    => $service_stdout_logfile_keep,   
  service_stdout_logfile_maxsize => $service_stdout_logfile_maxsize,
  shell                          => $shell,                         
  storm_messaging_transport      => $storm_messaging_transport,
  supervisor_childopts           => $supervisor_childopts,          
  supervisor_slots_ports         => $supervisor_slots_ports,       
  ui_childopts                   => $ui_childopts,                  
  uid                            => $uid,                           
  user                           => $user,                          
  user_description               => $user_description,              
  user_ensure                    => $user_ensure,                   
  user_home                      => $user_home,                     
  user_manage                    => $user_manage,                   
  user_managehome                => $user_managehome,               
  worker_childopts               => $worker_childopts,
  zookeeper_servers              => $zookeeper_servers,
}
if str2bool($enable_drpc) {
 class { 'storm::dprc': service_environment => $service_environment }
}
if str2bool($enable_logviewer)  {
 class { 'storm::logviewer': service_environment => $service_environment }
}
if str2bool($enable_supervisor) {
 class { 'storm::supervisor': service_environment => $service_environment }
}
if str2bool($enable_ui) {
 class { 'storm::ui': service_environment => $service_environment }
}
if str2bool($enable_nimbus) {
 class { 'storm::nimbus': service_environment => $service_environment }
}
}
