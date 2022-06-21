#!/usr/bin/env bash
# ex: set fdm=marker
# usage bash docker_tools.sh
#/ Usage:
#/       ./build.sh -r "REGISTRY/NAME" [OPTIONS]
#/
#/    -c|--context)
#/       the context in which to do the `docker build`
#/
#/    -r|--registry)
#/       the name of the image or registry to push to [required]
#/
#/    -t|--tag)
#/       the tag to assign the docker image
#/
#/    -n|--no-cache)
#/       do not use the cache when building this image
#/
#/    -f|--file)
#/       the Dockerfile to specify during build
#/
#/    -h|-?|--help)
#/       show this help and exit
#/
#/    -s|--start)
#/       start the container after building
# 
# environment 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-"Some Project Name in $DIR"}
DOCKER_FILE="Dockerfile"
TAG="latest"
NOCACHED=""
CONTEXT="."
MODE="build"
# 
# functions 
die() { # 
  echo -e "\033[31mFAILURE:\033[39m $1"
  exit 1
} # 
warn() { # 
  echo -e "\033[33mWARNING:\033[39m $1"
} # 
show_help() { # 
  grep '^#/' "${BASH_SOURCE[0]}" | cut -c4- || \
    die "Failed to display usage information"
} # 
#
# arguments 
while :; do
  case $1 in # check arguments 
    -c|--context) # Context for image to be built in 
      CONTEXT=$2
      shift 2
    -t|--tag) # Docker tag 
      TAG=$2
      shift 2
      ;; # 
    -n|--no-cache) # build without cache 
      NOCACHED="--no-cache"
      shift
      ;; # 
    -f|--file) # Dockerfile to use 
      DOCKER_FILE=$2
      shift 2
      ;; # 
    -r|--registry) # the registry to push to
      REGISTRY="$2"
      shift
      ;;
    -h|-\?|--help) # help 
      show_help
      exit
      ;; #
    -s|--start) # start the container
      MODE="start"
      shift
        ;;
    -?*) # unknown argument 
      warn "Unknown option (ignored): $1"
      shift
      ;; # 
    *) # default 
      break # 
  esac # 
done
# 


if [ "$MODE" = "build" ]; then
    # build docker image
    info "BUILDING $REGISTRY:$TAG using $DOCKER_FILE and these flags:"
    info "\t$NOCACHED"
    docker build -f "$DOCKER_FILE" $NOCACHED  \
    -t "$REGISTRY:$TAG" $CONTEXT || die "Image failed to build."
    docker push "$REGISTRY:$TAG" || die "Couldn't push $REGISTRY:$TAG"
        
elif [ "$MODE" = "start" ]; then
    # run docker container
    info "DEPLOYING $REGISTRY:$TAG using $DOCKER_FILE and these flags:"
    info "\t$NOCACHED"
    docker run --rm  \
    "$REGISTRY":"$TAG" \ 
        
fi



