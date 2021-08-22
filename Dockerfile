FROM azul/zulu-openjdk-alpine:13.0.6-13.37.21-jre-headless

ARG kafka_version=2.7.0
ARG scala_version=2.13
ARG glibc_version=2.33-r0
ARG vcs_ref=unspecified
ARG build_date=unspecified

LABEL org.label-schema.name="docker_kafka" \
      org.label-schema.description="Apache Kafka 2.7.0" \
      org.label-schema.build-date="${build_date}" \
      org.label-schema.vcs-url="https://github.com/kcheung00/docker_kafka" \
      org.label-schema.vcs-ref="${vcs_ref}" \
      org.label-schema.version="${scala_version}_${kafka_version}" \
      org.label-schema.schema-version="1.0"

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/opt/kafka \
    GLIBC_VERSION=$glibc_version

ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY download-kafka.sh start-kafka.sh broker-list.sh create-topics.sh versions.sh /tmp/

RUN apk add --no-cache bash curl jq docker \
 && chmod a+x /tmp/*.sh \
 && mv /tmp/start-kafka.sh /tmp/broker-list.sh /tmp/create-topics.sh /tmp/versions.sh /usr/bin \
 && sync && /tmp/download-kafka.sh \
 && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
 && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
 && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} \
 && rm /tmp/* \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
 && apk add --no-cache --allow-untrusted glibc-${GLIBC_VERSION}.apk \
 && rm glibc-${GLIBC_VERSION}.apk

COPY overrides /opt/overrides

VOLUME ["/docker_kafka"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
