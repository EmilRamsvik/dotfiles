# Keyboard Maestro macro exports

Diffable XML exports of Keyboard Maestro macro groups, one `.kmmacros` file
per group, produced by `scripts/export-km-macros.sh`.

- To restore a group, double-click its `.kmmacros` file (or drag it into
  Keyboard Maestro) to re-import it.
- To keep this directory current automatically, run the export script from a
  Keyboard Maestro macro on a periodic trigger, or from a `launchd`/cron job.
