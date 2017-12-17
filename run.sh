#!/bin/bash
set -e
gcloud auth activate-service-account --key-file=/opt/google_credentials.json
(gsutil mb -p ${PROJECT_NAME} -c multi_regional gs://${BUCKET}/) || true
gcsfuse -o nonempty ${BUCKET} /mount
$@
