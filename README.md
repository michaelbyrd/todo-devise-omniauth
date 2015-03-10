# Scaffolded Todo list with Devise and Github authentication using OmniAuth

This is a very simple rails app that sets "Log in with Github" for a rails app.

### Links
- [Devise](https://github.com/plataformatec/devise)
- [Omniauth](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview)
- [omniauth-github](https://github.com/intridea/omniauth-github)
- [Multiple strategies](http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/)

### Basic [Devise](https://github.com/plataformatec/devise)
- rails new NAME
- Gemfile add: gem 'devise'
- bundle install
- rails generate devise:install (follow the instructions in terminal)
- rails generate devise MODEL (commonly User)
- rails generate devise:views (to customize the views)

#### Devise helpers
- before_action :authenticate_user!
- user_signed_in?
- current_user

### Use [Omniauth](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview) to login with [Github](https://github.com/intridea/omniauth-github)
- [Authorize your app on github](https://github.com/settings/applications/new)
- Authorization callback url
- Gemfile add: gem 'omniauth', gem 'omniauth-github'

- in config/intializers/devise.rb
  - config.omniauth :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_APP_SECRET'], scope: 'user,public_repo'

- devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

- create omniauth_callbacks_controller.rb

- in User.rb
  - :omniauthable, :omniauth_providers => [:github]
  - def self.from_omniauth(auth)

- generate a migration
  - add_column :users, :provider, :string
  - add_column :users, :uid, :string


### On Heroku
- heroku config:set GITHUB_APP_ID =
- heroku config:set GITHUB_APP_SECRET =
