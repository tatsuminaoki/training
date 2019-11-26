FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

RUN gem install bundler

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install
RUN mkdir -p /app

WORKDIR /app
ADD . /app
RUN yarn install

EXPOSE 3000
CMD bundle exec rails server -p 3000 -b 0.0.0.0
