# https://github.com/thoughtbot/shoulda-matchers#getting-started
RSpec.configure do |config|
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      # test framework
      with.test_framework :rspec
      # libraries
      with.library :rails
    end
  end
end
