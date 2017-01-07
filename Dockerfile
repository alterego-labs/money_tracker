FROM elixir:1.3.2
MAINTAINER Sergey Gernyak <sergio@alterego-labs.com>

ARG MONEY_TRACKER_SECRET_KEY_BASE
ARG MONEY_TRACKER_MYSQL_DB
ARG MONEY_TRACKER_MYSQL_HOST
ARG MONEY_TRACKER_MYSQL_USER
ARG MONEY_TRACKER_MYSQL_PASSWORD
ARG MONEY_TRACKER_HOST

ENV MIX_ENV=prod
ENV MONEY_TRACKER_MYSQL_HOST ${MONEY_TRACKER_MYSQL_HOST}
ENV MONEY_TRACKER_MYSQL_USER ${MONEY_TRACKER_MYSQL_USER}
ENV MONEY_TRACKER_MYSQL_DB ${MONEY_TRACKER_MYSQL_DB}
ENV MONEY_TRACKER_MYSQL_PASSWORD ${MONEY_TRACKER_MYSQL_PASSWORD}
ENV MONEY_TRACKER_SECRET_KEY_BASE ${MONEY_TRACKER_SECRET_KEY_BASE}

RUN apt-get update && apt-get install -y build-essential git-core mysql-client

RUN mkdir -p /app

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

COPY . ./

RUN mix deps.get && mix deps.compile
RUN mix compile
RUN mix phoenix.digest
RUN mix release --verbosity=verbose

EXPOSE 8888

CMD ["rel/money_tracker/bin/money_tracker", "console"]