FROM alpine:latest

LABEL maintainer="none"

RUN apk add --no-cache nano sudo git xfce4 faenza-icon-theme bash tigervnc xfce4-terminal firefox mtr wget wireguard-tools openssh \
    && adduser -h /home/alpine -s /bin/bash -S -D alpine && echo -e "alpine\nalpine" | passwd alpine \
    && echo 'alpine ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && git clone https://github.com/novnc/noVNC /opt/noVNC \
    && git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify \
    && ln /opt/noVNC/vnc.html /opt/noVNC/index.html \
    && echo -e "\n\n\n" | ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 \
    && echo -e "Port 22\nAddressFamily any\nListenAddress 0.0.0.0\nListenAddress ::\nHostKey /root/.ssh/id_ed25519" >> /etc/ssh/sshd_config

USER alpine
WORKDIR /home/alpine

RUN mkdir -p /home/alpine/.vnc \
    && echo -e "-Securitytypes=none" > /home/alpine/.vnc/config \
    && echo -e "#!/bin/bash\nstartxfce4 &" > /home/alpine/.vnc/xstartup \
    && echo -e "alpine\nalpine\nn\n" | vncpasswd

COPY entry.sh /entry.sh

CMD [ "/bin/bash", "/entry.sh" ]
