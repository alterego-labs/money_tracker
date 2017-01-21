FROM elixir:1.3.2
MAINTAINER Sergey Gernyak <sergio@alterego-labs.com>

ARG MONEY_TRACKER_SECRET_KEY_BASE
ARG MONEY_TRACKER_DB_NAME
ARG MONEY_TRACKER_DB_HOST
ARG MONEY_TRACKER_DB_USER
ARG MONEY_TRACKER_DB_PASSWORD
ARG MONEY_TRACKER_HOST

ENV MIX_ENV=prod
ENV MONEY_TRACKER_DB_HOST ${MONEY_TRACKER_DB_HOST}
ENV MONEY_TRACKER_DB_USER ${MONEY_TRACKER_DB_USER}
ENV MONEY_TRACKER_DB_NAME ${MONEY_TRACKER_DB_NAME}
ENV MONEY_TRACKER_DB_PASSWORD ${MONEY_TRACKER_DB_PASSWORD}
ENV MONEY_TRACKER_SECRET_KEY_BASE ${MONEY_TRACKER_SECRET_KEY_BASE}

RUN apt-get update && apt-get install -y build-essential git-core mysql-client

RUN mkdir -p /app

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

COPY . ./

RUN mix compile
RUN mix phoenix.digest
RUN mix release --verbosity=verbose

EXPOSE 8888

CMD ["rel/money_tracker/bin/money_tracker", "console"]
