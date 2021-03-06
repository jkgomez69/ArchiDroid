#!/sbin/sh

#     _             _     _ ____            _     _
#    / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
#   / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
#  / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
# /_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|
#
# Copyright 2014-2015 Łukasz "JustArchi" Domeradzki
# Contact: JustArchi@JustArchi.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Mounts device
# $1 - Mount point
# $2 - Target device

set -e

if [[ -z "$1" || -z "$2" ]]; then
	exit 1
fi

# Check if it's mounted already
if mount | grep -qi "$1"; then
	exit 0
fi

# Check if mount point exists, if not, create one
if [[ ! -e "$1" ]]; then
	mkdir -p "$1"
fi

# Stage 1 - fstab
mount "$1" || true # If fstab has proper entry for our filesystem, providing path only is enough. However, this may fail if filesystem differs or fstab has no entry
if mount | grep -qi "$1"; then
	exit 0
fi

# Stage 2 - kernel
mount -t auto "$2" "$1" || true # This will handle all known by kernel filesystems, from /proc/filesystems. If we fail here, it's over
if mount | grep -qi "$1"; then
	exit 0
fi

# All stages failed
exit 1
