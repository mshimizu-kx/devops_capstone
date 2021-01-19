#!/bin/bash

# Mount S3
echo "${AWS_KEY}:${AWS_SECRET_KEY}" > passwd && chmod 600 passwd

echo "bucket: ${S3_BUCKET}"
echo "mount point: ${S3_MOUNT_POINT}"
s3fs "${S3_BUCKET}" "${S3_MOUNT_POINT}" -o passwd_file=passwd -o allow_other

# Start q
cd src
nohup q init_hdb.q < /dev/null >> /logs/hdb_$(date +%Y%m%d_%H%M%S).log 2>&1 &

# Wait forever
tail -f /dev/null