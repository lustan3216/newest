source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.2'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'

gem 'nokogiri'
gem 'jquery-rails'
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

gem 'redis', '~> 3.3', '>= 3.3.3'
gem 'sidekiq', '~> 4.2.7'
gem 'sidekiq-cron', '~> 0.6.3'

gem 'active_model_serializers', '~> 0.10.0'
gem 'oj'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'rack-mini-profiler'