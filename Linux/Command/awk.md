## AWK

awk is command text manipulation to print like `cut`.

### Usage

`awk [options] filepath`

```bash
[localhost@localhost ~]$ cat example.txt
1:2:3:4:5:6
7:8:9:10:11:12
[localhost@localhost ~]$ awk -F: '{print $2}' example.txt
2
8
```

Details:
- `-F` is used for delimiter like, colon, comma, etc.
- `'{print $n}'` is used for printing number of column, $n ($2) printing column number 2.

### Help

```bash
[localhost@localhost ~]$ awk --help
Usage: awk [POSIX or GNU style options] -f progfile [--] file ...
Usage: awk [POSIX or GNU style options] [--] 'program' file ...
POSIX options:		GNU long options: (standard)
	-f progfile		--file=progfile
	-F fs			--field-separator=fs
	-v var=val		--assign=var=val
Short options:		GNU long options: (extensions)
	-b			--characters-as-bytes
	-c			--traditional
	-C			--copyright
	-d[file]		--dump-variables[=file]
	-D[file]		--debug[=file]
	-e 'program-text'	--source='program-text'
	-E file			--exec=file
	-g			--gen-pot
	-h			--help
	-i includefile		--include=includefile
	-I			--trace
	-l library		--load=library
	-L[fatal|invalid|no-ext]	--lint[=fatal|invalid|no-ext]
	-M			--bignum
	-N			--use-lc-numeric
	-n			--non-decimal-data
	-o[file]		--pretty-print[=file]
	-O			--optimize
	-p[file]		--profile[=file]
	-P			--posix
	-r			--re-interval
	-s			--no-optimize
	-S			--sandbox
	-t			--lint-old
	-V			--version

To report bugs, see node `Bugs' in `gawk.info'
which is section `Reporting Problems and Bugs' in the
printed version.  This same information may be found at
https://www.gnu.org/software/gawk/manual/html_node/Bugs.html.
PLEASE do NOT try to report bugs by posting in comp.lang.awk,
or by using a web forum such as Stack Overflow.

gawk is a pattern scanning and processing language.
By default it reads standard input and writes standard output.

Examples:
	awk '{ sum += $1 }; END { print sum }' file
	awk -F: '{ print $1 }' /etc/passwd

```
