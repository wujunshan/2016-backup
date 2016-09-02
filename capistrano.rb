gem_group :development do
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano3-puma', '~> 1.2', '>= 1.2.1'
end
run_bundle
run "cap install"
git add: "."
git commit: %Q{ -m 'capistrano' }


# capistrano-rails
uncomment_lines 'Capfile', /require.*bundle/
uncomment_lines 'Capfile', /require.*assets/
uncomment_lines 'Capfile', /require.*migrations/
git add: "."
git commit: %Q{ -m 'capistrano-rails' }

# capistrano-rbenv
uncomment_lines 'Capfile', /require.*rbenv/
insert_into_file 'config/deploy.rb', :after=> /set\s:keep_releases.*\s/ do
  <<-EOS.strip_heredoc
    # https://github.com/capistrano/bundler
    set :bundle_jobs, 4 # default: nil, only available for Bundler >= 1.4
    # https://github.com/capistrano/rbenv
    set :rbenv_type, :system # or :user, depends on your rbenv setup
    set :rbenv_ruby, '2.3.1'
    set :rbenv_prefix, "RBENV_ROOT=\#{fetch(:rbenv_path)} RBENV_VERSION=\#{fetch(:rbenv_ruby)} \#{fetch(:rbenv_path)}/bin/rbenv exec"
    set :rbenv_map_bins, %w{rake gem bundle ruby rails}
    set :rbenv_roles, :all # default value
  EOS
end
git add: "."
git commit: %Q{ -m 'capistrano-rbenv' }

# capistrano3-puma
insert_into_file 'Capfile', :after => /require.*passenger.*\s/ do
  <<-EOS.strip_heredoc
    require 'capistrano/puma'
    require 'capistrano/puma/nginx'
  EOS
end
git add: "."
git commit: %Q{ -m 'capistrano3-puma' }


# App
gsub_file 'config/deploy.rb', /set.*my_app_name/  do |match|
  match.gsub('my_app_name', app_path.basename.to_s)
end

uncomment_lines 'config/deploy.rb', /ask\s:branch/
uncomment_lines 'config/deploy.rb', /set\s:deploy_to/
uncomment_lines 'config/deploy.rb', /set\s:linked_dirs/
