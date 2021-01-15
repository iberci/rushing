FROM elixir

RUN apt-get -y update && apt-get -y install nodejs postgresql-client inotify-tools

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

COPY . /app
WORKDIR /app

ENV MIX_ENV=dev
ENV XDG_CONFIG_HOME=/src/config

RUN mix local.hex --force && mix local.rebar --force

#COPY mix.exs mix.lock ./
#COPY config config
#RUN mix deps.get
#RUN mix deps.compile

#COPY assets assets
#RUN cd assets && npm install && npm run deploy
#RUN mix phx.digest
#
#COPY priv priv
#COPY lib lib
#RUN mix compile

#ENV HOME=/app

RUN mix do compile
CMD ["/app/entrypoint.sh"]
