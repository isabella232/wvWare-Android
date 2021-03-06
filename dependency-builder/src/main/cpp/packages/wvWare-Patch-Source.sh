#!/bin/sh
set -eu

THIS_FILE=$(readlink -f "$0")
BASEDIR=$(dirname "$THIS_FILE")

patch $1/wvRTF.c $BASEDIR/wvWare-Patch-Source-wvRTF.c.patch
patch -p0 <$BASEDIR/wvWare-Patch-Source-printf-redirect.patch

rm $1/config.sub

NOCONFIGURE=1 $1/autogen.sh
