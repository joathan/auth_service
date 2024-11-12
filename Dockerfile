FROM ruby:3.3.0

RUN apt-get update -qq && apt-get install -y build-essential libxml2-dev libxslt1-dev default-libmysqlclient-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config set force_ruby_platform true
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
