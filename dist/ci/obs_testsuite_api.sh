#!/bin/sh
#
# This script runs both API unit and integration tests 
#

###############################################################################
# Job configuration template
###############################################################################
#
# Project name: obs_testsuite_api
# Description:
#   OBS API testsuite on git master branch.
#
#   Updates source code repository and runs unit and integration tests.
#
# Source Code Management:
#   Git:
#     Repositories: git://github.com/openSUSE/open-build-service.git
#     Branches to build: master
#     Repository browser: githubweb
#       URL: https://github.com/openSUSE/open-build-service
#     Excluded Regions:
#       src/webui/.*
#       docs/.*
#
# Build Triggers:
#   Poll SCM:
#     Schedule: */5 * * * *
#
# Build:
#   Execute shell:
#     Command: sh dist/ci/obs_testsuite_api.sh
#
# Post Build Actions:
#   Publish JUnit test result report:
#     Test report XMLs: src/api/results/*.xml
#   Publish Rails Notes report: 1
#     Rake working directory: src/api
#   Publish Rails stats report: 1
#     Rake working directory: src/api
#

###############################################################################
# Script content for 'Build' step
###############################################################################
#
# Either invoke as described above or copy into an 'Execute shell' 'Command'.
#

set -xe
. `dirname $0`/obs_testsuite_common.sh

setup_git
setup_api

cd src/api

echo "Invoke rake"
rake --trace ci:setup:testunit test CI_REPORTS=results || true
cd ../..

echo "Output test.log"
cat src/api/log/test.log
echo

echo "Remove log/tmp files to save disc space"
rm -rf src/api/{log,tmp}/*
