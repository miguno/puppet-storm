class storm::supervisor inherits storm {

  if !($service_ensure in ['present', 'absent']) {
    fail("service_ensure parameter must be 'present' or 'absent'")
  }

  if $service_manage == true {

    supervisor::service {
      $service_name_supervisor:
        ensure                 => $service_ensure,
        enable                 => $service_enable,
        command                => "${command} supervisor",
        directory              => '/',
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
      exec { 'restart-storm-supervisor':
        command     => "supervisorctl restart ${service_name_supervisor}",
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
