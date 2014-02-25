class storm::config inherits storm {

  file { $config:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template($config_template),
    require => [ Package['storm'], File[$log_dir], File[$local_dir] ],
  }

}
