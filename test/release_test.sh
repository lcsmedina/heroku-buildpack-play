#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testReleasedYamlDoesNotIncludeDefaultProcWhenProcfileIsPresent() {
  touch ${BUILD_DIR}/Procfile
  expectedReleaseYAML=`cat <<EOF
---
config_vars:
  JAVA_OPTS: -Xmx300m -Xss512k -XX:CICompilerCount=2
  PLAY_OPTS: --%prod -Dprecompiled=true
addons:
  cloudinary
  newrelicapm
  sendgrid
EOF`

  release
  assertCapturedEquals "${expectedReleaseYAML}"
}

testReleasedYamlHasDefaultProcessType() {
  expectedReleaseYAML=`cat <<EOF
---
config_vars:
  JAVA_OPTS: -Xmx300m -Xss512k -XX:CICompilerCount=2
  PLAY_OPTS: --%prod -Dprecompiled=true
addons:
  cloudinary
  newrelicapm
  sendgrid
default_process_types:
  web:    play run --http.port=\\$PORT \\$PLAY_OPTS
EOF`

  release
  assertCapturedEquals "${expectedReleaseYAML}"
}
