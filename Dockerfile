FROM ruby:3

ARG DEBIAN_FRONTEND=noninteractive

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

WORKDIR /usr/src/app

COPY Gemfile* ./
RUN bundle install

COPY package*.json ./
RUN yarn install

COPY . .

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

CMD ["rails", "server"]
