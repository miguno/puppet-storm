# Change log

## 1.0.13 (January 21, 2015)

IMPROVEMENTS

* Support worker.xml logback configuration for Storm 0.10+


## 1.0.12 (August 08, 2014)

IMPROVEMENTS

* Add Storm DRPC support. (thanks andrewserff) [GH-3]
* bootstrap: Use new GitHub.com URL for retrieving raw user content.


## 1.0.11 (April 24, 2014)

IMPROVEMENTS

* Move user/group management into a separate Puppet class `storm::users` to enforce correct resource ordering
  regardless of whether the module should or should not manage the user/group.  This way we can make sure that the user
  and group are available before we set permissions on files and directories.

BACKWARDS INCOMPATIBILITIES

* Remove the `$group_manage` parameter.  The `$user_manage` parameter now enables/disables both the user and the group
  management.


## 1.0.10 (April 11, 2014)

IMPROVEMENTS

* Support `$config_map` parameter.  This parameter, whose value must be a hash, will be converted into a YAML fragment
  that will be appended to the end of the Storm configuration file (`storm.yaml`).


## 1.0.9 (April 08, 2014)

IMPROVEMENTS

* Remove `puppetlabs/stdlib` from `Modulefile` to decouple us from PuppetForge.


## 1.0.8 (March 24, 2014)

IMPROVEMENTS

* Add `compile` test to `storm::logviewer`, `storm::nimbus`, `storm::supervisor`, `storm::ui`.


## 1.0.7 (March 21, 2014)

* Add input validation for `$service_environment` parameter.

BUG FIXES

* Fix unit tests for `$service_environment` parameter.


## 1.0.6 (March 21, 2014)

IMPROVEMENTS

* The classes `storm::{logviewer,nimbus,supervisor,ui}` each support the class parameter `$service_environment`.  This
  parameter adds environment variables to their respective supervisord service via the `environment` setting of
  supervisord.  Example: `storm::nimbus::service_environment: 'FOO="bar",HELLO="world"'`.  See `environment` in
  [Supervisord section values](http://www.supervisord.org/configuration.html#supervisord-section-values).


## 1.0.5 (March 19, 2014)

IMPROVEMENTS

* Add basic support for running the [logviewer](http://storm.incubator.apache.org/2013/12/08/storm090-released.html)
  daemon.


## 1.0.4 (March 17, 2014)

IMPROVEMENTS

* Add `$user_manage` and `$group_manage` parameters.
* Initial support for testing this module.
    * A skeleton for acceptance testing (`rake acceptance`) was also added.  Acceptance tests do not work yet.

BACKWARDS INCOMPATIBILITY

* Change default value of `$package_ensure` from "latest" to "present".
* Puppet module fails if run on an unsupported platform.  Currently we only support the RHEL OS family.


## 1.0.3 (March 11, 2014)

IMPROVEMENTS

* Recursively create `$local_dir` if needed.

BUG FIXES

* Require Storm package before creating `$storm_rpm_log_dir` symlink.


## 1.0.2 (February 28, 2014)

IMPROVEMENTS

* Storm log directory has 0755 permissions (from 0750) to simplify integration with logging/monitoring tools.


## 1.0.1 (February 27, 2014)

BACKWARDS INCOMPATIBILITY

* Storm log files have been moved from `/opt/storm/logs/` to `/var/log/storm/` to better follow filesystem hierarchy
  standards. (thanks pabrahamsson) [GH-1]

BUG FIXES

* Properly create a symlink from `/opt/storm/logs/` to actual `$log_dir` when `$log_dir` value is set to a value
  different from `/opt/storm/logs/`.


## 1.0.0 (February 25, 2014)

* Initial release.
