#!/bin/bash
set -e

#debootstrap
echo "---> debootstrapping"
fakechroot debootstrap --include="$PACKAGES" --variant=fakechroot --variant=minbase $SUITE $BUILDDIR $MIRROR
