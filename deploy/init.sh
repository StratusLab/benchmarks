#!/bin/bash

if [ -f /mnt/context.sh ]; then
  . /mnt/context.sh
fi


if [ -f /mnt/$ROOT_PUBKEY ]; then
        mkdir -p /root/.ssh/
        echo "StrictHostKeyChecking  no" > /root/.ssh/config
        cat /mnt/$ROOT_PUBKEY >> /root/.ssh/authorized_keys
        chmod -R 600 /root/.ssh/
fi

#if [ -f /mnt/$MPI_ENV ]; then
#	cat /mnt/$MPI_ENV >> /root/.bashrc
#fi

