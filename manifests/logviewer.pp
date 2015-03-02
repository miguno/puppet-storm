# == Class storm::logviewer
#
# === Parameters
#
# [*service_environment*]
#   Configures the `environment` setting of the supervisord service.
#   A comma-separted string of key/value pairs for environment variables in the form 'KEY="val",KEY2="val2"' that will
#   be placed in the supervisord process' environment (and as a result in all of its child process' environments).
#   Example: 'FOO="bar",HELLO="world"' sets the environment variables `FOO` and `HELLO` to "bar" and "world",
#   respectively.
class storm::logviewer(
  $service_environment = '',
) inherits storm {

  validate_string($service_environment)

  if !($service_ensure in ['present', 'absent']) {
    fail('service_ensure parameter must be "present" or "absent"')
  }

  if $service_manage == true {

    supervisor::service {
      $service_name_logviewer:
        ensure                 => $service_ensure,
        enable                 => $service_enable,
        command                => "${command} logviewer",
        directory              => '/',
        environment            => $service_environment,
        user                   => $user,
        group                  => $group,
        autorestart            => $service_autorestart,
        startsecs              => $service_startsecs,
        retries                => $service_retries,
        stdout_logfile_maxsize => $service_stdout_logfile_maxsize,
        stdout_logfile_keep    => $service_stdout_logfile_keep,
        stderr_logfile_maxsize => $service_stderr_logfile_maxsize,
        stderr_logfile_keep    => $service_stderr_logfile_keep,
        stopsignal             => 'KILL',
        stopasgroup            => true,
        require                => [ Class['storm::config'], Class['::supervisor'] ],
    }

    if $service_enable == true {
      exec { 'restart-storm-logviewer':
        command     => "supervisorctl restart ${service_name_logviewer}",
        path        => ['/usr/bin', '/usr/sbin', '/sbin', '/bin'],
        user        => 'root',
        refreshonly => true,
        subscribe   => File[$config],
        onlyif      => 'which supervisorctl &>/dev/null',
        require     => Class['::supervisor'],
      }
    }

  }

}
