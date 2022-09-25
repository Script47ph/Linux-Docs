## Centered Text in Bash

This is a simple function that will center text in a terminal window.

```sh
#!/bin/bash
function print_centered {
     [[ $# == 0 ]] && return 1

     declare -i TERM_COLS="$(tput cols)"
     declare -i str_len="${#1}"
     [[ $str_len -ge $TERM_COLS ]] && {
          echo "$1";
          return 0;
     }

     declare -i filler_len="$(( (TERM_COLS - str_len) / 2 ))"
     [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
     filler=""
     for (( i = 0; i < filler_len; i++ )); do
          filler="${filler}${ch}"
     done

     printf "%s%s%s" "$filler" "$1" "$filler"
     [[ $(( (TERM_COLS - str_len) % 2 )) -ne 0 ]] && printf "%s" "${ch}"
     printf "\n"

     return 0
}
```

### Usage

Put the function in your bash script and call it with `print_centered your_text`.

```bash
[local@localhost ~]$ cat test.sh
#!/bin/bash
function print_centered {
     [[ $# == 0 ]] && return 1

     declare -i TERM_COLS="$(tput cols)"
     declare -i str_len="${#1}"
     [[ $str_len -ge $TERM_COLS ]] && {
          echo "$1";
          return 0;
     }

     declare -i filler_len="$(( (TERM_COLS - str_len) / 2 ))"
     [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
     filler=""
     for (( i = 0; i < filler_len; i++ )); do
          filler="${filler}${ch}"
     done

     printf "%s%s%s" "$filler" "$1" "$filler"
     [[ $(( (TERM_COLS - str_len) % 2 )) -ne 0 ]] && printf "%s" "${ch}"
     printf "\n"

     return 0
}

print_centered "Hello World"
[local@localhost ~]$
[local@localhost ~]$ bash test.sh
                                      Hello Sekai
[local@localhost ~]$
```

This function can also create horizontal bar with an easy way. Just call it with `print_centered "-" "-"` or `print_centered "=" "="`.


```bash
[local@localhost ~]$ bash test.sh
---------------------------------------------------------------------------------------
=======================================================================================
[local@localhost ~]$
```

### Original Source
- [TrinityCoder](https://gist.github.com/TrinityCoder) on [Gist Github](https://gist.github.com/TrinityCoder/911059c83e5f7a351b785921cf7ecdaa)