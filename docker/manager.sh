#!/bin/bash

PWD=$(pwd)

PG_LOCAL_DATA="$PWD/docker/pg/data"

DB_CONTAINER_NAME="money_tracker_pg_container"
APP_CONTAINER_NAME="money_tracker_container"

function get_container_pid_by_name() {
  echo `docker ps -a | grep "$1" | cut -d " " -f 1`;
}

function stop_container_by_name() {
  local pid=`get_container_pid_by_name "$1"`
  if [ -n "$pid" ];
  then
    echo "Stopping $1 container..."
    docker rm -f $pid > /dev/null;
  fi
}

function check_status() {
  local db_container_pid=`get_container_pid_by_name $DB_CONTAINER_NAME`;
  local app_container_pid=`get_container_pid_by_name $APP_CONTAINER_NAME`;
  if [ -n "$db_container_pid" ] && [ -n "$app_container_pid" ]; then
    echo "Running"
  else
    echo "Not running"
  fi
}

function run_pg_container() {
  echo "Running PG container";
  if [ ! -d "$PG_LOCAL_DATA" ]; then
    mkdir -p $PG_LOCAL_DATA
  fi

  source ./docker/pg/vars.env;

  docker run \
    --name $DB_CONTAINER_NAME \
    -e POSTGRES_USER=$PG_USER_LOGIN \
    -e POSTGRES_PASSWORD=$PG_USER_PASSWORD \
    -v $PG_LOCAL_DATA:/var/lib/postgresql/data \
    -d -p 5432:5432 postgres:9.6.1
  sleep 10
}

function stop_pg_container() {
  echo "Stopping PG container...";
  stop_container_by_name "money_tracker_pg_container";
}

function install_mix_dependencies() {
  echo "Starting installing MIX dependencies..."
  docker run \
    --rm --memory="512M" \
    -w="/app" \
    -v $PWD:/app \
    -e MIX_ENV=prod \
    --entrypoint=/app/docker/mix_deps_install.sh \
    elixir:1.3.2
}

function install_npm_dependencies() {
  echo "Starting installing NPM dependencies..."
  docker run \
    --rm --memory="512M" \
    -w="/app" \
    -v $PWD:/app \
    --entrypoint=/app/docker/npm_deps_install.sh \
    node:6.9.4
}

function build_web_container() {
  echo "Building web container..."
  source $PWD/docker/money_tracker.env
  docker build \
    --build-arg MONEY_TRACKER_SECRET_KEY_BASE=$MONEY_TRACKER_SECRET_KEY_BASE \
    --build-arg MONEY_TRACKER_HOST=$MONEY_TRACKER_HOST \
    --build-arg MONEY_TRACKER_DB_USER=$MONEY_TRACKER_DB_USER \
    --build-arg MONEY_TRACKER_DB_PASSWORD=$MONEY_TRACKER_DB_PASSWORD \
    --build-arg MONEY_TRACKER_DB_NAME=$MONEY_TRACKER_DB_NAME \
    --build-arg MONEY_TRACKER_DB_HOST=$MONEY_TRACKER_DB_HOST \
    -t money_tracker_image .
}

function run_web_container() {
  echo "Running web container..."
  docker run \
    --name $APP_CONTAINER_NAME \
    --link $DB_CONTAINER_NAME:db_host \
    -d -p 8888:8888 -i money_tracker_image
}

function stop_web_container() {
  echo "Stopping web container..."
  stop_container_by_name "money_tracker_container";
}

function run_mix_command() {
  echo "Running mix command '$1' on web container..."
  docker run \
    --rm \
    --env-file $PWD/docker/money_tracker.env \
    --link $DB_CONTAINER_NAME:db_host \
    money_tracker_image $1
}

case "$1" in
  "build")
    install_mix_dependencies;
    install_npm_dependencies;
    build_web_container;
    rm -rf _build/;
    rm -rf deps/;
    rm -rf node_modules;;
  "run")
    run_pg_container;
    run_mix_command "mix do ecto.create, ecto.migrate";
    run_web_container;;
  "stop")
    stop_web_container;
    stop_pg_container;;
  "status")
    check_status;;
  "run_custom_mix")
    run_mix_command "mix $2";;
esac
