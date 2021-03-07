FROM ruby:3

RUN apt-get update -qq && apt-get install -y nodejs npm

RUN npm install -g yarn

WORKDIR /usr/src/app

RUN gem install bundler:1.17.2

COPY Gemfile* ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

CMD ["rails", "server"]
