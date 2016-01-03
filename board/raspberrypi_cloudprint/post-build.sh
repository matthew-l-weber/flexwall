#!/bin/sh
target=$1
board=$2
echo "Using target folder [$target]..."
echo "Using board folder [$board]..."

failed()
{
   echo "FAILED: $1"
   exit 1
}

cp $board/cmdline.txt $target/../images/rpi-firmware/ -f || failed "copy of cmdline.txt"
exit 0
