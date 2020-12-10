FROM google/cloud-sdk:251.0.0-slim

COPY src/*.sh /app/
RUN apt-get update && apt-get install -y mysql-client && \
   apt-get clean && \ 
   rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/app/dump-and-save.sh"]