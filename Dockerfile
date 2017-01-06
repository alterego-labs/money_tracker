FROM elixir:1.3.2
MAINTAINER Sergey Gernyak <sergio@alterego-labs.com>

ENV MIX_ENV=prod

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
