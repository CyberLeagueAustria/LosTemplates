# Alpine 3.21.3
# Rust 1.83

##################
# Builder system #
##################
FROM docker.io/library/alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c AS builder

# Install apk dependencies if needed
RUN apk update && apk add --no-cache cargo make libc6-compat && rm -rf /var/cache/apk/*

COPY . /tmp/build/
RUN make -C /tmp/build/ challenge
# Copy final binary to dist
# CACHEBUST is a Docker trick to invalidate the cache at a exact point
# if not, when docker has cached the compilation it wouldn't output
# the binary to our dist/ directory so we can pack it for distribution
ARG CACHEBUST=1
CMD cp /tmp/build/challenge /dist/challenge

#################
# Runner system #
#################
FROM docker.io/library/alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

# Install apk dependencies if needed
RUN apk update && apk add --no-cache socat libgcc coreutils && rm -rf /var/cache/apk/*

# Copy challenge required files
RUN mkdir -p /app
COPY --from=builder /tmp/build/challenge /app/challenge
RUN chmod +x /app/challenge
COPY flag.txt /flag.txt
COPY entrypoint.sh /app/entrypoint.sh

SHELL ["/bin/sh", "-c"]
CMD socat -T 60 TCP-LISTEN:1337,fork,nodelay,reuseaddr,pktinfo EXEC:"/usr/bin/timeout -k 5 ${TIMEOUT} /app/entrypoint.sh"
