FROM elixir

RUN apt-get -y update && apt-get -y install build-essential npm nodejs postgresql-client inotify-tools

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

COPY . /app
WORKDIR /app

ENV MIX_ENV=dev
ENV XDG_CONFIG_HOME=/src/config

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get 
RUN mix deps.compile 
RUN mix do compile
RUN mix phx.digest

RUN cd assets && npm install && cd ..
CMD ["/usr/bin/entrypoint.sh"]
