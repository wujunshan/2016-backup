gem 'active_model_serializers', '~> 0.10.2'
gem 'rack-cors', '~> 0.4.0'

run_bundle
run "bundle exec spring stop"
run "spring binstub --remove --all"

# ActiveModelSerializers
create_file 'config/initializers/json_api.rb' do
  <<-EOS.strip_heredoc
    ActiveModel::Serializer.config.adapter = :json_api
    Mime::Type.register "application/json", :json, %w( text/x-json application/jsonrequest application/vnd.api+json )
  EOS
end


# Rack CORS Middleware
application do
  <<-EOS.strip_heredoc.indent(4)

    # Rack CORS Middleware
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  EOS
end

run "bundle exec spring binstub  --all"
git add: '.'
git commit: %Q< -m 'oh-my-rails: api' >
