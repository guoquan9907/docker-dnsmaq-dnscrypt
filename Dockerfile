#
# Dockerfile for chinadns
#

FROM debian:buster
MAINTAINER guoquan <guoquan9907@gmail.com>

ENV DNS_URL  https://codeload.github.com/zfl9/chinadns-ng/tar.gz/latest
ENV DNS_FILE chinadns-ng-latest.tar.gz
ENV DNS_MD5 e0caeeb35d2b5fbd0a7e2c13d12ed4eb

RUN apt-get update \
    && apt-get install -y build-essential curl dnsmasq supervisor dnscrypt-proxy ipset\
    && mkdir chinadns \
        && cd chinadns \
        && curl -sSL ${DNS_URL} -o ${DNS_FILE} \
        && echo "${DNS_MD5} ${DNS_FILE}" | md5sum -c \
        && tar xzf ${DNS_FILE} --strip 1 \
        && make install \
        && cd ../../ \
        && rm -rf chinadns \
    && apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ADD ./dnscrypt-proxy.toml /etc/dnscrypt-proxy/
RUN mkdir /chinadns-ng
ADD ./chinadns-ng.sh /chinadns-ng/
ADD ./chnlist.txt /chinadns-ng/
ADD ./chnroute.ipset /chinadns-ng/
ADD ./gfwlist.txt /chinadns-ng
ADD ./accelerated-domains.china.conf /etc/dnsmasq.d/
ADD ./bogus-nxdomain.china.conf /etc/dnsmasq.d/
ADD ./services.conf /etc/supervisor/conf.d/

EXPOSE 53/tcp 53/udp

CMD supervisord -n -c /etc/supervisor/supervisord.conf
