install vncserver (arch: tigervnc, suse: xorg-x11-Xvnc)

```
$ sudo vim /etc/systemd/system/x0vncserver.service
```

```
[Unit]
Description=Remote desktop service (VNC) for :0 display
Requires=display-manager.service
After=network-online.target
After=display-manager.service

[Service]
Type=simple
ExecStartPre=/usr/bin/bash -c "/usr/bin/systemctl set-environment XAUTHORITY=$(find /var/run/sddm/ -type f)"
ExecStart=/usr/bin/x0vncserver -display=:0 -rfbport=59000 -PAMService=login -PlainUsers="*" -SecurityTypes=TLSPlain
Restart=on-failure
RestartSec=500ms

[Install]
WantedBy=multi-user.target
```

```
$ sudo systemctl enable --now x0vncserver
```

Connect with your fav vnc-viewer to your.ip.number.here::5900

With this, you can boot the computer and access with a vnc-viewer getting the sddm login screen. You will take over the session at your computer so if you are already logged in, your vnc-viewer will log in to exactly that, while you still can control your computer physically ofc, you just see what the vnc session is doing live on the screen.
Naturally you can have it sleeping just like we discussed earlier, connecting with ssh, enabling the service, vnc:ing and then disabling the service again.
But this is the only way I found not interfering with your ability to log in physically to your computer while having vncserver running simultaniously.
