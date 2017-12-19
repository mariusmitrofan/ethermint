#!/bin/bash
set -e
gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
(gsutil mb -p ${PROJECT_NAME} -c multi_regional gs://${BUCKET}/) || true
mkdir -p ${FUSE_MOUNT_DIR}
gcsfuse -o nonempty ${BUCKET} ${FUSE_MOUNT_DIR}
exec $@
