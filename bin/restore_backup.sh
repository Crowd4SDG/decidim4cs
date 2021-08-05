#!/usr/bin/env bash
rm -rf /dst/backup/pg-prod/*
#rm -rf /dst/backup/public/*
#rm -rf /dst/backup/storage/*
#tar -xv -C /dst  --strip-components=2 -f /root/restore.tar.gz
tar -xv -C /dst -f /root/restore.tar.gz
chown -R $USER_ID:$GROUP_ID /dst/backup/public
chown -R $USER_ID:$GROUP_ID /dst/backup/storage

