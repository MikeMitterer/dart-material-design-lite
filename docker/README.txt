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


/var/lib/boot2docker/profile
    # some more ls aliases
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

Create

    docker create --name vol-mdl-live -v /Volumes/Daten/DevLocal/DevDart/MaterialDesignLite/build/example:/data mikemitterer/mdl-data

    docker create --name vol-mdl-live \
        -v /Volumes/Daten/DevLocal/DevDart/MaterialDesignLite/build/example\
            :/usr/share/nginx/html mikemitterer/mdl-data

    docker run -ti --volumes-from vol-mdl-live mikemitterer/mdl-data bash


