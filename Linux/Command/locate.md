## LOCATE

locate is command like find but more than powerfull to searching/locate file directory.

### Usage

`locate path patternwanttosearch`
    
```bash
[localhost@localhost ~]$ locate /etc/ hosts
/etc/hosts
/etc/hosts.atm
/etc/ImageMagick-7/type-ghostscript.xml
/etc/avahi/hosts
/etc/cloud/templates/hosts.alpine.tmpl
/etc/cloud/templates/hosts.arch.tmpl
/etc/cloud/templates/hosts.debian.tmpl
/etc/cloud/templates/hosts.freebsd.tmpl
/etc/cloud/templates/hosts.gentoo.tmpl
/etc/cloud/templates/hosts.photon.tmpl
/etc/cloud/templates/hosts.redhat.tmpl
/etc/cloud/templates/hosts.suse.tmpl
/usr/share/factory/etc/hosts
[localhost@localhost ~]$
```

**Note**

- By default, locate is not pre-installed on linux.
- Use root user for avoiding permission denied while scanning.

### Help
```bash
[local@localhost ~]$ locate --help
Usage: plocate [OPTION]... PATTERN...

  -b, --basename         search only the file name portion of path names
  -c, --count            print number of matches instead of the matches
  -d, --database DBPATH  search for files in DBPATH
                         (default is /var/lib/plocate/plocate.db)
  -i, --ignore-case      search case-insensitively
  -l, --limit LIMIT      stop after LIMIT matches
  -0, --null             delimit matches by NUL instead of newline
  -N, --literal          do not quote filenames, even if printing to a tty
  -r, --regexp           interpret patterns as basic regexps (slow)
      --regex            interpret patterns as extended regexps (slow)
  -w, --wholename        search the entire path name (default; see -b)
      --help             print this help
      --version          print version information
```
