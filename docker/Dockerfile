FROM debian:buster-slim
RUN apt-get update && \
    apt-get install file curl python3-minimal ca-certificates --no-install-recommends -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    apt-get clean
RUN useradd -m -s /bin/bash user
COPY dilbert.sh /home/user/dilbert
COPY date-generator.py /home/user/date-generator.py
COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 0700 /docker-entrypoint.sh \
    /home/user/date-generator.py \
    /home/user/dilbert
VOLUME [ '/home/user/Pictures/dilbert' ]
ENTRYPOINT [ "/docker-entrypoint.sh" ]