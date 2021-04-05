FROM swift:5.3.3
# Dependency: libsqlite3
RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev

# Copy over the generated Package.*, and resolve if changed.
COPY Package.* ./
RUN swift package resolve

# The usual copying over
COPY Sources ./Sources
COPY Tests ./Tests
RUN swift package resolve


RUN swift build

# Exposes ports for Docker container
EXPOSE 8080
EXPOSE 56700:56700/udp

CMD swift run --skip-build --skip-update
