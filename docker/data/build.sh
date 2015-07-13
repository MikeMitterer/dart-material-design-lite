#/bin/bash

cd ../../build/example/ && tar czvf ../../docker/server/example.tgz * && cd -

docker build -t mikemitterer/mdl-data .