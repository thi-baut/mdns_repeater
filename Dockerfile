ARG BASE=alpine
FROM $BASE

# Create a non-root user named 'mdns'
RUN addgroup -S mdns && adduser -S mdns -G mdns

ARG arch=arm
ENV ARCH=$arch

RUN apk update && apk upgrade

# COPY qemu/qemu-$ARCH-static* /usr/bin/

ADD mdns-repeater.c mdns-repeater.c
RUN apk add --no-cache build-base \
    && gcc -O3 -o /bin/mdns-repeater mdns-repeater.c -DHGVERSION="\"1\"" \
    && apk del build-base \
    && rm -rf /var/cache/apk/* /tmp/*

COPY run.sh /run.sh
ENV options="" hostNIC=eth0 dockerNIC=docker_gwbridge

# Switch to the non-root user
# USER mdns
CMD mdns-repeater -f ${options} ${hostNIC} ${dockerNIC}

ENTRYPOINT [ "/run.sh" ]
