#------------------------------------------------------------------------------
#
# Build this file: docker build -t mikemitterer/mdl-server .
#
# Run the server:
#   docker run --name mdl-server -d mikemitterer/mdl-server
#   docker run --name mdl-server -d -p 80:80 mikemitterer/mdl-server
#
#   docker run --volumes-from mdl-data --name mdl-server -d -p 80:80 mikemitterer/mdl-server
#
# Test with bash:
#   docker run -ti mikemitterer/mdl-server bash
#   docker run --volumes-from mdl-data --name mdl-server -ti mikemitterer/mdl-server bash
#   docker run --volumes-from vol-mdl-live --name mdl-server -ti mikemitterer/mdl-server bash
#------------------------------------------------------------------------------

FROM nginx

MAINTAINER Mike Mitterer <office@mikemitterer.at>

COPY .bashrc /root/

# RUN apt-get update && apt-get install -y \
#    rsync

RUN mv /usr/share/nginx/html /usr/share/nginx/html.off
# RUN ln -s /data /usr/share/nginx/html
# RUN rsync -avz --delete /data/ /usr/share/nginx/html/

# ADD example.tgz /usr/share/nginx/html/






