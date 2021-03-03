Rails.application.routes.draw do
  devise_for :users

  mount Grapes::API => '/'
  mount Twitter::API => '/'
  # get "test/default"
end
