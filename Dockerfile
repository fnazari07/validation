# Dockerfile
FROM ruby:3.1

WORKDIR /app

COPY . .

RUN bundle install

CMD ["ruby", "lib/runner.rb"]
