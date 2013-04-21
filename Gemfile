source 'https://rubygems.org'

gem 'rails',                '3.2.12'
gem 'rb-readline'
gem 'rake',                 '0.8.7'
gem 'gravatar_image_tag',   '0.1.0'
gem 'cocaine',              '~> 0.5.1'
gem 'paperclip',            '~> 3.0'
gem 'aws-s3',               :require => 'aws/s3'
gem 'aws-sdk',              '~> 1.3.4'
gem 'jquery-rails'
gem 'thin'

#gem "mongoid",             "~> 3.0.0"
#gem "mongoid-paperclip",   :require => "mongoid_paperclip"

group :production do
  gem 'pg'
end

group :development do
  gem 'rspec-rails', '2.13.0'
end

group :test do
  gem 'rspec', '2.13.0'
end

group :development, :test do
  gem 'sqlite3'
  gem 'annotate'
  gem 'spork', '0.9.2'
  gem 'webrat'
end

group :assets do
  gem 'therubyracer'
  gem 'sass-rails',         '~> 3.2.3'
  #gem 'coffee-rails',       '~> 3.2.1'
  gem 'uglifier',           '>= 1.0.3'
end
