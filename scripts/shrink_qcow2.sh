#!/bin/bash
set -e
if [ "$EUID" -ne 0 ]; then
    >&2 echo "Must be run as root."
    exit 1
fi
if [ $# -ne 1 ]; then
        echo "Usage: $0 <qcow2_image_file>. Exiting now!"
        exit 1
fi

IMAGE_FILE=$1

if [ ! -f ${IMAGE_FILE} ]; then
        echo "The file: ${IMAGE_FILE} does not exist. Exiting now!"
        exit 1
fi

virt-sparsify --compress --format qcow2 ${IMAGE_FILE} ${IMAGE_FILE}.shrunk

chmod --reference="${IMAGE_FILE}" "${IMAGE_FILE}.shrunk"
chown --reference="${IMAGE_FILE}" "${IMAGE_FILE}.shrunk"
