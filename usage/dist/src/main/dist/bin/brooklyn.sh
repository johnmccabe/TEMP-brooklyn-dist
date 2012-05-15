#!/bin/bash
#
# Brooklyn
#

#set -x # debug

# Get root direcotry of distribution
ROOT=$(cd $(dirname $0)/.. && pwd)

# The CLI main class to run
CLASS=brooklyn.cli.Main

# Default memory
if [ -z "${JAVA_OPTS}" ] ; then
    JAVA_OPTS="-Xmx256m -Xmx1g -XX:MaxPermSize=256m"
fi

# Set up the environment
CLASSPATH="${CLASSPATH:-.}:${BROOKLYN_CLASSPATH}:${ROOT}/lib/*:${ROOT}/app:${ROOT}/app/*"
JAVA_OPTS="-Dbrooklyn.localhost.address=127.0.0.1 ${JAVA_OPTS}"

# Start Brooklyn
exec java ${JAVA_OPTS} -cp "${CLASSPATH}" ${CLASS} $@
