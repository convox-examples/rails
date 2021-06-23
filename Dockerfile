FROM ruby:3.0.0-buster as development

ENV RAILS_ENV development

# install system dependencies
RUN apt-get update && apt-get install -y nodejs npm postgresql-client
RUN npm install -g yarn

# set working directory
WORKDIR /usr/src/app

# bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install

# yarn install
COPY package.json yarn.lock ./
RUN yarn install --check-files

# copy the rest of the app
COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]

EXPOSE 3000

from development as production

ARG SECRET_KEY_BASE

ENV NODE_ENV production
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

RUN rake assets:precompile