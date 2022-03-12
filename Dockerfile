ARG MIX_ENV="prod"
ARG BUILDER_IMAGE="hexpm/elixir:1.13.3-erlang-24.2.1-debian-bullseye-20210902-slim"
ARG RUNNER_IMAGE="debian:bullseye-20210902-slim"

FROM ${BUILDER_IMAGE} as build

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git npm \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# install mix dependencies
COPY apps/ebanx/mix.exs apps/ebanx/
COPY apps/ebanx_web/mix.exs apps/ebanx_web/
COPY mix.exs mix.lock ./

RUN mix deps.get --only $MIX_ENV

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/runtime.exs config/"${MIX_ENV}".exs config/
RUN mix deps.compile

COPY apps/ebanx_web/priv apps/ebanx_web/priv

COPY apps/ebanx_web/assets apps/ebanx_web/assets
RUN cd apps/ebanx_web && mix assets.deploy

RUN mix compile

COPY config/runtime.exs config/

# Compile the release
RUN true
COPY apps apps

# COPY rel rel
RUN mix release

# prepare release image
FROM ${RUNNER_IMAGE}
RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales bash postgresql-client \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

  # Set the locale
RUN sed -i '/pt_BR.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR:en
ENV LC_ALL pt_BR.UTF-8

ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

RUN mkdir /app
WORKDIR /app
RUN chown nobody /app

COPY --from=build --chown=nobody:root /app/_build/"${MIX_ENV}"/rel/ebanx_umbrella .

COPY entrypoint.sh .

USER nobody

ENV HOME=/app

# Usage:
#  * build: sudo docker image build -t elixir/ebanx .
#  * shell: sudo docker container run --rm -it --entrypoint "" -p 127.0.0.1:4000:4000 elixir/ebanx sh
#  * run:   sudo docker container run --rm -it -p 127.0.0.1:4000:4000 --name ebanx elixir/ebanx
#  * exec:  sudo docker container exec -it ebanx sh
#  * logs:  sudo docker container logs --follow --tail 100 ebanx
CMD ["bash", "/app/entrypoint.sh"]