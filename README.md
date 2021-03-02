# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  3.0.0 (가장 최신으로!)

* System dependencies
  그레이프, 디바이스, jwt, faraday등을 사용합니다. 
  
  ruby '3.0.0'
  gem 'grape'
  gem 'devise'
  gem 'jwt'
  gem 'faraday'

  gem 'capistrano', '~> 3.11'
  gem 'capistrano-rails', '~> 1.4'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
  gem 'capistrano3-puma' 
  gem 'capistrano-secrets-yml', '~> 1.0.0'
  gem 'mysql2', '~> 0.5.3'
  # Make sure that `gem install mysql2 -v '0.5.3' --source 'https://rubygems.org/'`

* Configuration

* Database creation
  - 이번 프로젝트에서는 각자 편안한 것을 쓰시면 됩니다. 
  - 저는 이번엔 프로덕션에서는 mysql2를 사용할 예정입니다.

* Database initialization

* How to run the test suite
  - 커스텀 테스트 코드를 활용할 예정입니다. 

* Services (job queues, cache servers, search engines, etc.)
  - redis, sidekiq을 활용할 예정입니다.

* Deployment instructions
  - Capistrano를 사용합니다. 
  - 마지막 4주차에 프로덕션 파트를 다룰 예정입니다.

# rails_2021_03_full_stack
