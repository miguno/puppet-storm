# == Class storm::users
#
class storm::users inherits storm {

  if $user_manage == true {

    group { $group:
      ensure => $group_ensure,
      gid    => $gid,
    }

    user { $user:
      ensure     => $user_ensure,
      home       => $user_home,
      shell      => $shell,
      uid        => $uid,
      comment    => $user_description,
      gid        => $group,
      managehome => $user_managehome,
      require    => Group[$group],
    }
  }

}
