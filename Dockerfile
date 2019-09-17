FROM ruby:2.6.4 AS development

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

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

FROM development

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

RUN rake assets:precompile
