#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

# generates LICENSE files for source and binary,
# and for each of `projects-with-custom-licenses`

set -e

# update the extras-files file from projects-with-custom-licenses
cat projects-with-custom-licenses | awk '{ printf("%s/src/main/license/source-inclusions.yaml:", $0); }' | sed 's/:$//' > extras-files

unset BROOKLYN_LICENSE_SPECIALS
unset BROOKLYN_LICENSE_EXTRAS_FILES
unset BROOKLYN_LICENSE_MODE

# individual projects
for x in `cat projects-with-custom-licenses` ; do
  export BROOKLYN_LICENSE_MODE=`basename $x`
  echo MAKING LICENSES FOR: ${BROOKLYN_LICENSE_MODE}
  export BROOKLYN_LICENSE_SPECIALS=-DonlyExtras=true
  export BROOKLYN_LICENSE_EXTRAS_FILES=$x/src/main/license/source-inclusions.yaml
  cp licenses/`basename $x`/* licenses/source
  ./make-one-license.sh > LICENSE.autogenerated || ( echo FAILED. See details in tmp_stdout/err. && false )
  cp LICENSE.autogenerated ../$x/src/main/license/files/LICENSE
  unset BROOKLYN_LICENSE_SPECIALS
  unset BROOKLYN_LICENSE_EXTRAS_FILES
  unset BROOKLYN_LICENSE_MODE
done

# source build, at root
export BROOKLYN_LICENSE_MODE=source
echo MAKING LICENSES FOR: ${BROOKLYN_LICENSE_MODE}
export BROOKLYN_LICENSE_SPECIALS=-DonlyExtras=true 
./make-one-license.sh > LICENSE.autogenerated
cp LICENSE.autogenerated ../../../LICENSE
unset BROOKLYN_LICENSE_SPECIALS
unset BROOKLYN_LICENSE_MODE

# binary build, in dist
export BROOKLYN_LICENSE_MODE=binary
echo MAKING LICENSES FOR: ${BROOKLYN_LICENSE_MODE}
./make-one-license.sh > LICENSE.autogenerated
cp LICENSE.autogenerated ../src/main/license/files/LICENSE
unset BROOKLYN_LICENSE_MODE

