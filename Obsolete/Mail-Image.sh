#!/bin/sh

#   FILE: mail_image -- 
# AUTHOR: W. Michael Petullo <mike@flyn.org>
#   DATE: 31 May 2001
#
# Copyright (C) 2001 W. Michael Petullo <mike@flyn.org>
# All rights reserved.
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
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

tmpdir=`mktemp -d /tmp/mail-image-XXXXXX`

for i in $*; do
	cp $i $tmpdir
	tmpfile=${tmpdir}/`basename $i`
	mogrify -geometry '640x480>' $tmpfile
	attachments=${attachments},${tmpfile}
done

# Get rid of the leading comma.
attachments=`echo $attachments | sed 's/^,//g'`

balsa -a "$attachments"

rm -rf $tmpdir
