# Gems
gem 'seedbank', '~> 0.4.0'
gem 'rails-i18n', '~> 5.0'
gem 'aasm', '~> 4.11'
gem 'paranoia', '~> 2.2.0'
gem 'sidekiq', '~> 4.2'
gem 'sinatra', '~> 2.0.0.beta2'
gem 'whenever', '~> 0.9.7'
gem 'friendly_id', '~> 5.1'

gem_group :development, :test do
  gem 'dotenv-rails', '~> 2.1'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.7'
  gem 'timecop', '~> 0.8.1'
end

gem_group :development do
  gem 'annotate', '~> 2.7'
  gem 'foreman', '~> 0.82.0'
  gem 'guard-rspec', '~> 4.7'
  gem 'spring-commands-rspec', '~> 1.0'
  gem 'fuubar', '~> 2.2'
  gem 'pry-rails', '~> 0.3.4'
  gem 'rails-erd', '~> 1.5'
end

gem_group :test do
  gem 'database_cleaner', '~> 1.5'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker', '~> 1.6'
end

run_bundle
run "bundle exec spring stop"
run "bundle exec spring binstub --remove --all"

# App
remove_file 'README.md'
copy_file 'README.md'
copy_file 'CHANGELOG.md'

# I18n
remove_file 'config/locales/en.yml'
copy_file 'locale.rb', 'config/initializers/locale.rb'
directory 'locales/defaults', 'config/locales/defaults'
directory 'locales/models', 'config/locales/models'

# annotate
generate "annotate:install"

# seedbank
create_file 'db/seeds/development/.keep'

# sidekiq
# https://junnan.org/2015/08/sidekiq.html
prepend_to_file 'config/routes.rb', "require 'sidekiq/web'\n"
route("mount Sidekiq::Web => '/sidekiq'")
application "config.active_job.queue_adapter = :sidekiq"
copy_file 'sidekiq.yml', 'config/sidekiq.yml'

# whenever
run "wheneverize ."

# FriendlyId
generate "friendly_id"

# dotenv-rails
append_to_file '.gitignore', ".env\n"
copy_file 'environment', '.env'
copy_file 'environment', '.env.example'

# foreman
copy_file 'Procfile'

# rspec
generate 'rspec:install'
uncomment_lines 'spec/rails_helper.rb', /support.*require/

inject_into_class 'config/application.rb', 'Application' do
  <<-EOS.strip_heredoc.indent(4)
    # Setting for Rspec
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_spece: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  EOS
end

# factory_girl
copy_file 'factory_girl.rb', 'spec/support/factory_girl.rb'

# rspec - guard
run "bundle exec guard init rspec"
run 'bundle exec spring binstub rspec'
gsub_file 'Guardfile', /cmd: "bundle exec rspec"/, 'cmd: "spring rspec"'

# Fuubar
append_to_file '.rspec', '--format Fuubar'

# shoulda-matchers
copy_file 'shoulda_matchers.rb', 'spec/support/shoulda_matchers.rb'


run "bundle exec spring binstub  --all"
git add: '.'
git commit: %Q< -m 'oh-my-rails: common' >
