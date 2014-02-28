# Change log

## 1.0.2 (February 28, 2014)

IMPROVEMENTS:

* Storm log directory has 0755 permissions (from 0750) to simplify integration with logging/monitoring tools.


## 1.0.1 (February 27, 2014)

BACKWARDS INCOMPATIBILITY:

* Storm log files have been moved from `/opt/storm/logs/` to `/var/log/storm/` to better follow filesystem hierarchy
  standards. (thanks pabrahamsson) [GH-1]

BUG FIXES:

* Properly create a symlink from `/opt/storm/logs/` to actual `$log_dir` when `$log_dir` value is set to a value
  different from `/opt/storm/logs/`.


## 1.0.0 (February 25, 2014)

* Initial release.
