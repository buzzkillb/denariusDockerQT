#!/bin/bash
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker-xauth
mkdir -p ${HOME}/.denarius
xauth nlist ${DISPLAY} | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -
docker run -ti --rm -e "XAUTHORITY=${XAUTH}" -e "DISPLAY=${DISPLAY}" -v ${HOME}/.denarius:/data -v ${XAUTH}:${XAUTH} -v ${XSOCK}:${XSOCK} --name="denariusdockerqt" --user="${UID}:${GID}" buzzkillb/denariusdockerqt

