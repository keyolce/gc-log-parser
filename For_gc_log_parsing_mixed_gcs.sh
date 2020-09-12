#!/bin/bash
#set -ex
function die()
{
    echo "Error: $1" >&2
    exit 1
}


# First argument is log file path
[ -z "$1" ] && die "Log file not supplied"
# Second argument is type of gc
[ -z "$2" ] && die "type of gc not specified"

type=$2
type="($type)"


if [ $type == "(young)" ]; then
	command_for_gc_phases=$(sed -n -e "/$type/,/Times/ p" $1 | grep -E "\(young|Object Copy|Scan RS|Update RS|\[Other"| awk -F':' -v n1=0,n2=0,n3=0,n4=0,n5=0 '$1 ~ /Object/ {print n1 "-" $1 $5;n1++} $1 ~ /Scan/ {print n2 "-" $1 $5;n2++} $1 ~ /Update/ {print n3 "-" $1 $5;n3++} $1 ~ /Other/ {print n4 "-" $1 $2; n4++} $0 ~ /(young)/ {print n5 "- time" $4; n5++}'|cut -d',' -f1|awk 'NR%5 == 0{print $3} NR%5 == 1{printf "%s+",$3}  NR%5 == 2{printf "%s+",$5} NR%5 == 3{printf "%s+",$5} NR%5 == 4{printf "%s+", $5}'|awk -F'+' '{ print $0 "+" $2+$3+$4+$5}'|awk -F'+' '{print $1 " " $2 " " $3 " " $4 " " $5 " Total: " $6}')
else command_for_gc_phases=$(sed -n -e "/$type/,/Times/ p" $1 | grep -E "\(mixed|Object Copy|Scan RS|Update RS|\[Other"| awk -F':' -v n1=0,n2=0,n3=0,n4=0,n5=0 '$1 ~ /Object/ {print n1 "-" $1 $5;n1++} $1 ~ /Scan/ {print n2 "-" $1 $5;n2++} $1 ~ /Update/ {print n3 "-" $1 $5;n3++} $1 ~ /Other/ {print n4 "-" $1 $2; n4++} $0 ~ /(mixed)/ {print n5 "- time" $4; n5++}'|cut -d',' -f1|awk 'NR%5 == 0{print $3} NR%5 == 1{printf "%s+",$3}  NR%5 == 2{printf "%s+",$5} NR%5 == 3{printf "%s+",$5} NR%5 == 4{printf "%s+", $5}'|awk -F'+' '{ print $0 "+" $2+$3+$4+$5}'|awk -F'+' '{print $1 " " $2 " " $3 " " $4 " " $5 " Total: " $6}')
fi

command_for_concurrent_mark=$(grep "GC concurrent-mark-end" $1| cut -d':' -f4| awk '{print $1 " marking end"}')

aggregate_result="$command_for_gc_phases"$'\n'"$command_for_concurrent_mark"

echo "$aggregate_result" | sort -k1 -n
