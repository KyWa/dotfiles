=Understand and use essential tools=

==archive and compression utilites==

`tar` doesn't do compression it is an archive tool only. Other programs that compress can be used in line when running it. Common compression programs such as `gzip` and `bzip2` can be used natively. You can string options together instead of multiple `-o` strung together. `tar` will overwrite existing files sharing the same filename. 

Common Options:
        * `-c` --Create archive
        * `-v` --Verbose
        * `-f` --Is to use the specified filename
        * `-t` --List contents of an archive
        * `-z` --Uses `gzip` to compress/uncompress archive
        * `-j` --Uses `bzip2` to compress archive
        * `-x` --Extract the archive
        * `-d` --Checks differences of files in archive against working directory

Common Uses:

* Create archive of directory folder1
`tar -cvf newarchive.tar folder1/`
* Create archive and compress folder1
`tar -czvf newarchive.tar.gz folder1`
* Extract and uncompress archive newarchive.tar.gz
`tar -xzvf newarchive.tar.gz`

==redirection==

`<` *stdin*
`>` *stdout*
`2>` *stderr*

*stdin* (0)
*stdout* (1)
*stderr* (2)

* Send stderr to /dev/null and not terminal
`somecommand 2> /dev/null`
* Send stdout and stderr to file/log
`somecommand 2>&1 newfile.log`
* Input data from command
`somecommand < cat file.log`

==grep and regex==

`^` --Line starts with 
`$` --Line ends with

===grep common options===
- `-v` --Excludes context
- `-A` --After context [used via -A2 to show 2 lines after context]
- `-B` --Before context [used via -B2 to show 2 lines before context]
- `-i` --Ignore case

==hard and soft links==

Soft links do not alter permissions and use main file permissions. These are just shortcuts to allow for alternate paths to a given directory or file.

Hard links cannot traverse filesystems. Hard links are actually a link in the VFS and target the inode on the hard drive and the data still exists until all links to the inode are removed. The 3rd column on an ls -l shows how many links are targeting a file. Using find you can find those files via:

`find . -samefile /path/to/file`

==list and change permissions==

`u, g, o = User, Group, Others`

`r, w, x = Read, Write, Execute`

Directories need execute permission to go into them. When setting permissions with chmod, `X` is used recursivly to change permissions for only directories ensure scripts and other files do not become executable. 

Primary group is used when creating files, use newgrp to "login" to new group and have that group be the default group owner of new file/directory.

==read and use system documentation==

- `apropos` - search the manual page names and descriptions
- `mandb` - create or update the manual page index caches
- `man` - read manual page for a given program (older tool)
- `info` - tool for reading manuals and documentation for programs
- `/usr/share/doc` - location for README files and documentation of all* programs

`info` docs are stored in `/usr/share/info` and pressing ? will bring up a navigation menu. To search with `info` you muse pass --apropos in your command. `man` pages are stored in `/usr/share/man`. `man` uses `vi` keybindings and can be navigated with them.

==finding files==

- `locate` - find files by name
- `find`

`locate` uses a databse which is cached and regularly updated (`updatedb`)
