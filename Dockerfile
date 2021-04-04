FROM th089/swift:5.3.3
ARG FILENAME
ARG TOKEN

# Dependency: libsqlite3
RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev && apt-get install -y --no-install-recommends curl

# Copy over the generated Package.*, and resolve if changed.
COPY Package.* ./

RUN curl -fO https://cache.meetis.eu/cache/${TOKEN}/${FILENAME}.tar; if [ "$?" -eq 0 ] ; then tar -xvf ${FILENAME}.tar && rm ${FILENAME}.tar ; fi

RUN swift package resolve

# The usual copying over
COPY Tests ./Tests
COPY Sources ./Sources

RUN swift build

RUN tar -cvf ${FILENAME}.tar .build/ && curl -F "archive=@./${FILENAME}.tar" https://cache.meetis.eu/upload/${TOKEN}/${FILENAME} && rm ${FILENAME}.tar

# Exposes ports for Docker container
EXPOSE 8080
EXPOSE 56700:56700/udp

CMD swift run --skip-build --skip-update
