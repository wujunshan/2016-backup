gem 'active_model_serializers', '~> 0.10.2'
gem 'rack-cors', '~> 0.4.0'

run_bundle
run "bundle exec spring stop"
run "spring binstub --remove --all"

# ActiveModelSerializers
application 'ActiveModel::Serializer.config.adapter = :json_api'
append_to_file 'config/initializers/mime_types.rb' do
  <<-EOS.strip_heredoc
    # http://jsonapi.org.cn/
    Mime::Type.register "application/json", :json, %w( application/vnd.api+json text/x-json application/jsonrequest  )
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
