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

  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.7'
end

gem_group :test do
  gem 'database_cleaner', '~> 1.5'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker', '~> 1.6'
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


# rspec(debug)
generate 'rspec:install'
create_file 'spec/support/factory_girl.rb' do
  <<-EOS.strip_heredoc.indent(2)
    RSpec.configure do |config|
      # See http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
      config.include FactoryGirl::Syntax::Methods
    end
  EOS
end
uncomment_lines 'spec/rails_helper.rb', /support.*require/
insert_into_file 'spec/rails_helper.rb', :after => "RSpec.configure do |config|\n" do
  <<-EOS.strip_heredoc.indent(2)
    Shoulda::Matchers.configure do |config|
      config.integrate do |with|
        # Choose a test framework:
        with.test_framework :rspec
        with.library :rails
      end
    end
  EOS
end

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

git add: '.'
git commit: %Q< -m 'oh-my-rails: common' >
