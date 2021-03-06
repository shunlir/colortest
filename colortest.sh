#!/usr/bin/env bash

# Test 256 color support along with bold and dim attributes.
# Copyright (C) 2014  Egmont Koblinger
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# This file was originally taken from https://gitlab.gnome.org/GNOME/vte/raw/vte-0-58/perf/256test.sh

sep=':'

format_number() {
  # see https://www.compart.com/en/unicode/block/U+2500
  local c=$'\u2502'
  if [ $1 -lt 10 ]; then
    printf "$c %d" $1
  else
    printf "$c%02d" $(($1%100))
  fi
}

somecolors() {
  local from="$1"
  local to="$2"
  local prefix="$3"
  local line

  for line in \
      "\e[2mdim      " \
      "normal   " \
      "\e[1mbold     " \
      "\e[1;2mbold+dim "; do
    echo -ne "$line"
    i=$from
    while [ $i -le $to ]; do
      echo -ne "\e[$prefix${i}m"
      format_number $i
      i=$((i+1))
    done
    echo $'\e[0m\e[K'
  done
}

256colors()
{
  echo "-- 256 colors($3): SGR ${1}8${sep}5${sep}0..15 --"
  somecolors 0 15 "${1}8${sep}5${sep}"
}

allcolors() {
  echo "-- 8 standard colors($3): SGR ${1}0..${1}7 --"
  somecolors 0 7 "$1"
  echo
  echo "-- 8 bright colors($3): SGR ${2}0..${2}7 --"
  somecolors 0 7 "$2"
  echo
  sep=';'
  256colors $1 $2 $3
  echo
  sep=':'
  256colors $1 $2 $3
}

allcolors 3 9 forground
echo
allcolors 4 10 background
