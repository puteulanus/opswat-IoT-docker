FROM centos:centos7 as BUILD

RUN yum install -y git make gcc-c++ libcurl-devel && \
    git clone http://github.com/OPSWAT/Gears-open-source /opswat && \
    cd /opswat && \
    chmod +x build && \
    ./build

FROM alpine

# Install glibc
RUN apk --no-cache add ca-certificates libcurl jq caddy
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk && \
    apk add glibc-2.32-r0.apk && \
    rm -f glibc-2.32-r0.apk

ENV LD_LIBRARY_PATH=/usr/glibc-compat/lib:/lib64:/usr/lib64:/usr/lib:/lib

# Copy libs
COPY --from=BUILD /lib64/libstdc++.so.6 /lib64/
COPY --from=BUILD /lib64/libm.so.6 /lib64/
COPY --from=BUILD /lib64/libgcc_s.so.1 /lib64/
COPY --from=BUILD /lib64/libpthread.so.0 /lib64/
COPY --from=BUILD /lib64/libc.so.6 /lib64/
COPY --from=BUILD /lib64/libidn.so.11 /lib64/
COPY --from=BUILD /lib64/libssh2.so.1 /lib64/
COPY --from=BUILD /lib64/libssl3.so /lib64/
COPY --from=BUILD /lib64/libsmime3.so /lib64/
COPY --from=BUILD /lib64/libplds4.so /lib64/
COPY --from=BUILD /lib64/libplc4.so /lib64/
COPY --from=BUILD /lib64/libnspr4.so /lib64/
COPY --from=BUILD /lib64/libdl.so.2 /lib64/
COPY --from=BUILD /lib64/libgssapi_krb5.so.2 /lib64/
COPY --from=BUILD /lib64/libkrb5.so.3 /lib64/
COPY --from=BUILD /lib64/libk5crypto.so.3 /lib64/
COPY --from=BUILD /lib64/libcom_err.so.2 /lib64/
COPY --from=BUILD /lib64/liblber-2.4.so.2 /lib64/
COPY --from=BUILD /lib64/libldap-2.4.so.2 /lib64/
COPY --from=BUILD /lib64/libz.so.1 /lib64/
COPY --from=BUILD /lib64/libssl.so.10 /lib64/
COPY --from=BUILD /lib64/libcrypto.so.10 /lib64/
COPY --from=BUILD /lib64/librt.so.1 /lib64/
COPY --from=BUILD /lib64/libkrb5support.so.0 /lib64/
COPY --from=BUILD /lib64/libkeyutils.so.1 /lib64/
COPY --from=BUILD /lib64/libresolv.so.2 /lib64/
COPY --from=BUILD /lib64/libsasl2.so.3 /lib64/
COPY --from=BUILD /lib64/libselinux.so.1 /lib64/
COPY --from=BUILD /lib64/libcrypt.so.1 /lib64/
COPY --from=BUILD /lib64/libpcre.so.1 /lib64/
COPY --from=BUILD /lib64/libfreebl3.so /lib64/

# Copy opswat
COPY --from=BUILD /opswat /opswat

# Configure
WORKDIR /opswat
ENTRYPOINT ["sh","/opswat/run"]
