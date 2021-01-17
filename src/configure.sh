#!/bin/bash

echo "${AWS_KEY}:${AWS_SECRET_KEY}" > passwd && chmod 600 passwd
s3fs "${S3_BUCKET}" "${S3_MOUNT_POINT}" -o passwd_file=passwd  && tail -f /dev/null
