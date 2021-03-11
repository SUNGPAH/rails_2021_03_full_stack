Rails.application.routes.draw do
  devise_for :users

  # lib? folder? 
  mount Grapes::API => '/'
  
  # mount Twitter::API => '/'
  # get "test/default"
end

#https://wwww.ringleplus.com/api/v1/memo/create