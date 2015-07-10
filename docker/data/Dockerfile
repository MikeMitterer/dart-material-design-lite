#------------------------------------------------------------------------------
#
# Build this file: docker build -t mikemitterer/mdl-data .
#
# Create .tgz:
#   cd ../../build/example/ && tar czvf ../../docker/server/example.tgz * && cd -
#
# Run Volumne:
#   docker create --name mdl-data mikemitterer/mdl-data /bin/true
#
# Test with bash:
#   docker run -it mikemitterer/mdl-data bash
#------------------------------------------------------------------------------

FROM gliderlabs/alpine

MAINTAINER Mike Mitterer <office@mikemitterer.at>

RUN apk-install bash
RUN apk-install mc

RUN mkdir /data

VOLUME /data

COPY .bashrc /root/
ADD example.tgz /data/

CMD ["true"]
