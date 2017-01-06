#!/bin/bash

PWD=$(pwd)

MYSQL_DATA_FOLDER="$PWD/docker/mysql/data"

function stop_container_by_name {
  pid=`docker ps -a | grep "$1" | cut -d " " -f 1`;
  if [ -n "$pid" ];
  then
    echo "Stopping $1 container..."
    docker rm -f $pid > /dev/null;
  fi
}

function run_mysql_container {
  echo "Running mysql container..."
  docker run \
    --name money_tracker_mysql_container \
    --env-file ./docker/mysql/mysql.env \
    -v $MYSQL_DATA_FOLDER:/var/lib/mysql \
    -d -p 3306:3306 mysql:5.6
}

function stop_mysql_container {
  echo "Stopping mysql container..."
  stop_container_by_name "money_tracker_mysql_container";
}

function build_web_container {
  echo "Building web container..."
  docker build -t money_tracker_image .
}

function run_web_container {
  echo "Running web container..."
  docker run \
    --name money_tracker_container \
    --link money_tracker_mysql_container:mysql \
    -d -p 8888:8888 -i money_tracker_image
}

function stop_web_container {
  echo "Stopping web container..."
  stop_container_by_name "money_tracker_container";
}

function run_mix_command {
  echo "Running mix command '$1' on web container..."
  docker run \
    --rm \
    --link money_tracker_mysql_container:mysql \
    money_tracker_image $1
}

case "$1" in
  "build")
    build_web_container;;
  "run")
    run_mysql_container;
    run_mix_command "mix do ecto.create, ecto.migrate";
    run_web_container;;
  "stop")
    stop_web_container;
    stop_mysql_container;;
esac
