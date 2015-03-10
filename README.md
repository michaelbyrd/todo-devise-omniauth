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

##### config/intializers/devise.rb
  - config.omniauth :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_APP_SECRET'], scope: 'user,public_repo'

##### routes.rb
- devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

##### create omniauth_callbacks_controller.rb

```html
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
```

##### User.rb
  - :omniauthable, :omniauth_providers => [:github]
```ruby
def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    # user.name = auth.info.name   # assuming the user model has a name
    # user.image = auth.info.image # assuming the user model has an image
    # you can look at the other information that github sends [here](https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema)
  end
end
```

##### generate a migration
```ruby
class AddProviderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
```
