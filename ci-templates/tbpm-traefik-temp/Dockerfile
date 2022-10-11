FROM alpine:3.15
RUN apk --no-cache add ca-certificates tzdata
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) arch='armv6' ;; \
		aarch64) arch='arm64' ;; \
		x86_64) arch='amd64' ;; \
		s390x) arch='s390x' ;; \
		*) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
	esac; \
	wget https://github.com/traefik/traefik/releases/download/v2.8.3/traefik_v2.8.3_linux_amd64.tar.gz; \
	mv traefik_v2.8.3_linux_amd64.tar.gz traefik.tar.gz; \
	cp traefik.tar.gz /tmp/; \
	rm -rf traefik.tar.gz; \
	tar xzvf /tmp/traefik.tar.gz -C /usr/local/bin traefik; \
	rm -f /tmp/traefik.tar.gz; \
	chmod +x /usr/local/bin/traefik

COPY application-server-traefik-temp/entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY application-server-traefik-temp/ssl.crt /etc/traefik/certs/ssl.crt
COPY application-server-traefik-temp/ssl.key /etc/traefik/certs/ssl.key

RUN chmod +x /etc/traefik/certs/ssl.crt
RUN chmod +x /etc/traefik/certs/ssl.key

COPY application-server-traefik-temp/traefik-dynamic.yaml /etc/traefik/configfiles/traefik-dynamic.yaml
COPY application-server-traefik-temp/traefik.yaml /etc/traefik/traefik.yaml

RUN chmod +x /etc/traefik/configfiles/traefik-dynamic.yaml
RUN chmod +x /etc/traefik/traefik.yaml

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]

# Metadata
LABEL org.opencontainers.image.vendor="Traefik Labs" \
	org.opencontainers.image.url="https://traefik.io" \
	org.opencontainers.image.title="Traefik" \
	org.opencontainers.image.description="A modern reverse-proxy" \
	org.opencontainers.image.version="v2.8.3" \
	org.opencontainers.image.documentation="https://docs.traefik.io"