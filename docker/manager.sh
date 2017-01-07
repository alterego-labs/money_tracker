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

function install_mix_dependencies {
  echo "Starting installing MIX dependencies..."
  docker run \
    --rm --memory="512M" \
    -w="/app" \
    -v $PWD:/app \
    -e MIX_ENV=prod \
    --entrypoint=/app/docker/mix_deps_install.sh \
    elixir:1.3.2
}

function install_npm_dependencies {
  echo "Starting installing NPM dependencies..."
  docker run \
    --rm --memory="512M" \
    -w="/app" \
    -v $PWD:/app \
    node:6.9.4 npm install
}

function build_web_container {
  echo "Building web container..."
  source $PWD/docker/money_tracker.env
  docker build \
    --build-arg MONEY_TRACKER_SECRET_KEY_BASE=$MONEY_TRACKER_SECRET_KEY_BASE \
    --build-arg MONEY_TRACKER_HOST=$MONEY_TRACKER_HOST \
    --build-arg MONEY_TRACKER_MYSQL_USER=$MONEY_TRACKER_MYSQL_USER \
    --build-arg MONEY_TRACKER_MYSQL_PASSWORD=$MONEY_TRACKER_MYSQL_PASSWORD \
    --build-arg MONEY_TRACKER_MYSQL_DB=$MONEY_TRACKER_MYSQL_DB \
    --build-arg MONEY_TRACKER_MYSQL_HOST=$MONEY_TRACKER_MYSQL_HOST \
    -t money_tracker_image .
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
  "setup")
    mkdir $PWD/docker/mysql;
    mkdir $PWD/docker/mysql/data;
    touch $PWD/docker/money_tracker.env;
    touch $PWD/docker/mysql/mysql.env;;
  "build")
    install_mix_dependencies;
    install_npm_dependencies;
    build_web_container;
    rm -rf _build/;
    rm -rf deps/;
    rm -rf node_modules;;
  "run")
    run_mysql_container;
    run_mix_command "mix do ecto.create, ecto.migrate";
    run_web_container;;
  "stop")
    stop_web_container;
    stop_mysql_container;;
  "run_custom_mix")
    run_mix_command "mix $2";;
esac
