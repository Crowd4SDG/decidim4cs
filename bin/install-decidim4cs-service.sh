#!/usr/bin/env bash

loginctl enable-linger $USER
mkdir -p ~/.config/systemd/user
cp etc/decidim4cs.service ~/.config/systemd/user
systemctl --user enable decidim4cs
systemctl --user start decidim4cs
systemctl --user status decidim4cs
