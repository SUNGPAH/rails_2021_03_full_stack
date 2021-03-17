Rails.application.routes.draw do
  devise_for :users

  mount Grapes::API => '/'  
end

#https://wwww.ringleplus.com/api/v1/memo/create