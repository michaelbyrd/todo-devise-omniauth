# Todo

This is a very simple rails app that allows users to log in with Github. It uses a scaffolded model for todos and Devise/Omniauth for authentication.

### Links
* [devise](https://github.com/plataformatec/devise)
* [omniauth](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview)
* [omniauth-github](https://github.com/intridea/omniauth-github)
* [Multiple strategies](http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/)


#### In Gemfile
```ruby
gem 'devise'
gem 'omniauth'
gem 'omniauth-github'
```

##### Basic Devise
* rails generate devise:install (follow the instructions in terminal)
* rails generate devise MODEL (commonly User)
* rails generate devise:views (to customize the views)

##### Devise helpers
```ruby
before_action :authenticate_user!
user_signed_in?
current_user
```

##### Use Omniauth to login with Github
* Authorize your app on github [here](https://github.com/settings/applications/new)
* Authorization callback url

##### In config/intializers/devise.rb
```ruby
config.omniauth :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_APP_SECRET'], scope: 'user,public_repo'
```
##### In routes.rb
```ruby
devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
```
##### Create omniauth_callbacks_controller.rb

```ruby
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

##### In User.rb
add :omniauthable, :omniauth_providers => [:github]
```ruby
def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    # user.name = auth.info.name   # assuming the user model has a name
    # user.image = auth.info.image # assuming the user model has an image
  end
end
```
you can look at the other information that github sends in its [Auth Hash](https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema)

##### Generate a migration
```ruby
class AddProviderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
```
