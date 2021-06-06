FROM alpine:edge
MAINTAINER @zinaada

RUN apk add --update openssh \
&& rm  -rf /tmp/* /var/cache/apk/*
ARG SSH_PUBKEY
ENV SSH_PUBKEY=$SSH_PUBKEY
RUN ssh-keygen -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key >/dev/null
RUN ssh-keygen -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key >/dev/null
RUN mkdir /root/.ssh/
RUN mkdir /var/run/sshd
RUN echo "$SSH_PUBKEY" > /root/.ssh/authorized_keys
RUN chmod 0600 /root/.ssh/authorized_keys
RUN echo "root:$(head -32 /dev/urandom | md5sum)"|chpasswd

EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd","-D"]