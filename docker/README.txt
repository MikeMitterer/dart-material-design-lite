SSH into boot2docker
    b2d ssh
      user: docker
      pass: tcuser


Mount custom volume: (Volume name: DevLocal)

    /var/lib/boot2docker/bootlocal.sh: (chmod 700)

        #!/bin/sh
        # bash is not available!
        mkdir -p /Volumes/Daten/DevLocal
        mount -t vboxsf DevLocal /Volumes/Daten/DevLocal

Remove all docker containers
    http://goo.gl/KQdB2M

    docker rm $(docker ps -aq)

Remove all docker images
    docker
        docker rmi $(docker images -q)

    With "none"
        docker rmi `docker images | grep none | awk '{ print $3; }'`

    Week ago
        docker rmi `docker images | grep 'weeks ago' | awk '{ print $3; }'`

/var/lib/boot2docker/profile
    # some more ls aliases
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

Create

    docker create --name vol-mdl-live -v /Volumes/Daten/DevLocal/DevDart/MaterialDesignLite/build/example:/data mikemitterer/mdl-data

    docker create --name vol-mdl-live -v /Volumes/Daten/DevLocal/DevDart/MaterialDesignLite/build/example:/usr/share/nginx/html mikemitterer/mdl-data

    docker run -ti --volumes-from vol-mdl-live mikemitterer/mdl-data bash


