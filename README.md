# windows_administrator

ADMIN_LOGS  
allows you to display and delete events from Windows log stores. It provides a list of available stores and allows the user to delete events from a specific store, showing details like the file size, last modification, and the number of records before performing the action.

ADMIN_DACL  
manages Access Control Entry (ACE) rules on Windows files and directories, allowing:  
  - Displaying current access rules.  
  - Adding new access rules.  
  - Removing existing rules.  
  It includes a menu to facilitate usage.

ADMIN_BACKUP  
allows you to create backups of files and directories in Windows, with two main options:  
  - **Full Backup**: Creates a complete copy of the source folder to a specified destination, organizing the backup into a new folder with the current date.  
  - **Incremental Backup**: Copies only the new or modified files since the last full backup, comparing the contents of the source folder with the full backup.  
  It includes a menu to select the desired option or exit the program.

ADMIN_SHADOWS  
allows you to manage restore points in Windows. It includes functions to display, create, restore, and delete restore points. A menu is provided for the user to select the desired actions, and the state of the VSS (Volume Shadow Copy Service) is checked before performing any operations.

ADMIN_SERVICES  
allows users to list, display details, start, stop, create, and delete Windows services. Through a menu, users can manage system services, including filtering by state and assigning startup types.

ADMIN_WINDOWS  
allows you to manage processes in Windows. It offers functions to start, stop, suspend processes, view the status of threads in a process, and change their priorities. A menu is provided to facilitate the management of processes and their associated threads.
