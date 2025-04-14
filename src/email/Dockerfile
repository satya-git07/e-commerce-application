FROM ruby:3.2.2-slim AS base

FROM base AS builder
WORKDIR /tmp

COPY Gemfile Gemfile.lock ./

RUN apt-get update && apt-get install -y build-essential && bundle install

FROM base AS release
WORKDIR /email_server

COPY . .

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

EXPOSE ${EMAIL_PORT}
ENTRYPOINT ["bundle", "exec", "ruby", "email_server.rb"]

