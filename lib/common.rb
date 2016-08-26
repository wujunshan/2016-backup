gem 'seedbank', '~> 0.4.0'
gem 'rails-i18n', '~> 5.0'
gem 'aasm', '~> 4.11'
gem 'paranoia', '~> 2.2.0.pre'
gem 'sidekiq', '~> 4.1'
gem 'sinatra', '~> 2.0.0.beta2'

gem_group :development do
  gem 'annotate', '~> 2.7'
  gem 'foreman', '~> 0.82.0'
end

gem_group :development, :test do
  gem 'dotenv-rails', '~> 2.1'
end

run_bundle

# seedbank
create_file 'db/seeds/development/.keep'

# annotate
generate "annotate:install"

# foreman
create_file 'Procfile', "web: bundle exec rails s\n"

# rails-i18n
application "config.i18n.default_locale = 'zh-CN'"
copy_file 'zh-CN.yml', 'config/locales/zh-CN.yml'
copy_file 'active_record.yml', 'config/locales/active_record.yml'
remove_file 'config/locales/en.yml'

# dotenv-rails
append_to_file '.gitignore', ".env\n"
create_file '.env' do
  <<-EOS.strip_heredoc
    export SECRET_KEY_BASE=example
  EOS
end
run "cp .env{,.example}"

# sidekiq
prepend_to_file 'config/routes.rb', "require 'sidekiq/web'\n"
route("mount Sidekiq::Web => '/sidekiq'")

git add: '.'
git commit: %Q< -m 'oh-my-rails: common' >
