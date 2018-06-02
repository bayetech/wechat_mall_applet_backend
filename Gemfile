source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.5'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.4.10'
# Use Puma as the app server
gem 'puma', '~> 3.0'

gem 'figaro'
# Baye core logic, to run locally:
# $ bundle config --local local.baye-core /Users/guochunzhong/git/landlord/baye-core/
gem 'baye-core', git: 'git@git.coding.net:ericguo/landlord_baye-core.git', branch: :master

# Build JSON APIs with ease. Read more: https://github.com/rails-api/active_model_serializers
gem 'active_model_serializers', '~> 0.10.2'

gem 'ahoy_matey', '~> 1.6.1'

# $ bundle config --local local.cl2009 /Users/guochunzhong/git/landlord/cl2009/
gem 'cl2009', git: 'git@git.coding.net:ericguo/cl2009.git', branch: :master

gem 'sidekiq'
# Generates swagger-ui json files for Rails APIs with a simple DSL
gem 'swagger-docs'

gem 'redis'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.11'
gem 'wx_pay'

gem 'wechat'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', require: 'rack/cors'

group :production, :staging do
  gem 'exception_notification'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'pry'

  gem 'pry-byebug'
end

group :development do
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Use Capistrano for deployment
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
