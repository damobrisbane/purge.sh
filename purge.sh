#!/bin/sh
# 
# Recursive delete of old file versions
#
# $> DRYRUN=y /var/cache/distfiles/purge.sh /var/cache/distfiles
#
# keeping /var/cache/distfiles/github.com%2Fmoby%2Fterm%2F@v%2Fv0.0.0-20200312100748-672ec06f55cd.mod
# keeping /var/cache/distfiles/github.com%2Fminio%2Fsimdjson-go%2F@v%2Fv0.2.1.mod-
# keeping /var/cache/distfiles/golang.org%2Fx%2Ftext%2F@v%2Fv0.3.3.zip-
# keeping /var/cache/distfiles/libreoffice-7.4.4.2.tar.xz
# ! deleting /var/cache/distfiles/libreoffice-7.3.5.2.tar.xz
# ! deleting /var/cache/distfiles/libreoffice-7.3.5.2-patchset-01.tar.xz
# ! deleting /var/cache/distfiles/libreoffice-7.3.4.2.tar.xz
# ! deleting /var/cache/distfiles/libreoffice-7.2.6.2.tar.xz
# ! deleting /var/cache/distfiles/libreoffice-7.1.7.2.tar.xz
# keeping /var/cache/distfiles/libXdmcp-1.1.4.tar.xz
# 
 
#
# $> /var/cache/distfiles/purge.sh /var/cache/distfiles
#
# keeping /var/cache/distfiles/golang.org%2Fx%2Ftext%2F@v%2Fv0.3.3.zip-
# keeping /var/cache/distfiles/libreoffice-7.4.4.2.tar.xz
# deleting /var/cache/distfiles/libreoffice-7.3.5.2.tar.xz
# deleting /var/cache/distfiles/libreoffice-7.3.5.2-patchset-01.tar.xz
# deleting /var/cache/distfiles/libreoffice-7.3.4.2.tar.xz
# deleting /var/cache/distfiles/libreoffice-7.2.6.2.tar.xz
# deleting /var/cache/distfiles/libreoffice-7.1.7.2.tar.xz
# keeping /var/cache/distfiles/libXdmcp-1.1.4.tar.xz
# deleting /var/cache/distfiles/libXdmcp-1.1.3.tar.bz2
# keeping /var/cache/distfiles/git3-src/qt_qtbase.git/refs/ta
#
#


_DP_TARGET=${1:-.}
_L_FILES=$(find $_DP_TARGET -type f)

f_a_l_files() {
  local -n __L_FILES=$1
  local -n __A_L_FILES=$2
  for _FN in ${__L_FILES[@]}; do
    _L1=($(sed -E 's#(.*)-([0-9]+.[0-9]+.[0-9]+.*)#\1 \2#' <<<$_FN))
    _K=${_L1[0]} _V=${_L1[1]}
    [[ ${#__A_L_FILES[$_K]} -ne 0 ]] && _SEP=","
    __A_L_FILES[${_K}]+=${_SEP}${_V}
  done
}

declare -A _A_L_FILES

f_a_l_files _L_FILES _A_L_FILES
for _FN in ${!_A_L_FILES[@]}; do
  _L2=($(tr , ' ' <<<${_A_L_FILES[$_FN]}))
  [[ -n $DEBUG ]] && echo "_FN: $_FN (${#_L2[@]})"
  _L3a=($(printf '%s\0' ${_L2[@]}|sort -n -z --reverse |tr '\0' ' '))

  [[ -n $DEBUG ]] && echo "_L3a: ${_L3a[@]}"
  _L4a=${_L3a[@]:1:99}
  echo "keeping ${_FN}-${_L3a[0]}"
  for _FN2 in ${_L4a[@]}; do
    if [[ ! -n $DRYRUN ]]; then
      echo "deleting ${_FN}-${_FN2}"
      rm ${_FN}-${_FN2}
    else
      echo "! deleting ${_FN}-${_FN2}"
    fi
  done
done  
