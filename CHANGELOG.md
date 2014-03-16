# Change log

## 1.0.4 (March 16, 2014)

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
