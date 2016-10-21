FROM ruby:2.3

RUN sed -i 's/httpredir.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
            mysql-client \
            postgresql-client \
            sqlite3 \
            && rm -rf /var/lib/apt/lists/*

# see http://gems.ruby-china.org/
RUN gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.org

RUN gem install rails
