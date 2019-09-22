FROM debian:buster-slim
RUN apt-get update && \
    apt-get install file wget curl python3-minimal ca-certificates --no-install-recommends -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    apt-get clean
COPY dilbert.sh /dilbert
COPY date-generator.py /date-generator.py
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN useradd -m -s /bin/bash user && \
    chmod 0700 /docker-entrypoint.sh
VOLUME [ '/home/user/Pictures/dilbert' ]
ENTRYPOINT [ "/docker-entrypoint.sh" ]