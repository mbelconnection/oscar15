#!/bin/sh
##########
# This script should build a SF deployment archive

ant clean
ant

cd ..
tar cvfz build/tmp/oscar_rc.tar.gz --exclude \*/CVS/\* --exclude \*/CVS database install build/tmp/*.war
cd build

echo ----------
echo Run the following to upload the archive
echo - sftp \<sf_user\>@frs.sourceforge.net
echo - cd uploads
echo - put tmp/oscar.tar.gz
echo ----------
