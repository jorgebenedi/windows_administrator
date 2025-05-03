# windows_administrator

admin_logs: allows you to display and delete events from Windows log stores. It provides a list of available stores and lets the user delete events from a specific store, showing details like file size, last modification time, and record count before performing the action.

admin_DACL manages Access Control Entry (ACE) rules on Windows files and directories, enabling:

Viewing current access rules.

Adding new access rules.

Removing existing rules. Includes a menu for ease of use.

admin_backups: lets you create backups of files and directories in Windows, with two main options:

full_Backup: Creates a complete copy of the source folder to a specified destination, organizing backups into dated folders.

incremental_backup: Copies only new or modified files since the last full backup by comparing source and backup contents. Includes a menu for option selection.

admin_shadow: manages restore points in Windows. Functions include listing, creating, restoring, and deleting restore points. A menu guides user actions, and the VSS (Volume Shadow Copy Service) status is checked before operations.

admin_services: allows users to list, inspect, start, stop, create, and delete Windows services. Features a menu for system service management, including state filtering and startup type assignment.

admin_windows: handles Windows process management. Functions include starting, stopping, suspending processes, viewing thread statuses, and adjusting priorities. A menu simplifies process and thread management.
