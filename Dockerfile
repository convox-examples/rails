FROM ruby:3.0.0-buster as development

RUN apt-get update \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && apt-get install -y libqtwebkit4 libqt4-dev xvfb \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

EXPOSE 3000

WORKDIR /share
ADD Gemfile /share/Gemfile
RUN bundle config set with development
RUN bundle install

ADD package.json /share/package.json
RUN yarn install

ADD ./ /share

CMD ["rails", "server", "-b", "0.0.0.0"]