FROM	golang:1.12 as build
WORKDIR /conntrack-stats-exporter
COPY	go.mod go.sum ./
RUN	go mod download
COPY	. .
RUN	go mod verify
RUN	./build.sh

FROM	alpine:3.10
COPY	--from=build /conntrack-stats-exporter/conntrack-stats-exporter /usr/local/sbin/
RUN	apk update \
&&	apk --no-cache upgrade \
&& 	apk --no-cache add conntrack-tools curl
ENTRYPOINT	[ "/usr/local/sbin/conntrack-stats-exporter" ]
