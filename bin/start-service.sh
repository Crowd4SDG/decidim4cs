#!/usr/bin/env bash

systemctl --user stop decidim4cs
rm -rf decidim4cs/tmp/pids/server.pid
systemctl --user start decidim4cs
systemctl --user status decidim4cs

