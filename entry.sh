#!/bin/bash
sudo /usr/sbin/sshd
/usr/bin/vncserver :59 &
/opt/noVNC/utils/novnc_proxy --vnc 127.0.0.1:5959 2>&1
