Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #이렇게 해두면..서비스 단위로 하면 될려나?
  mount Grapes::API => '/'
  mount Twitter::API => '/'

  #good tokno 
  # get "test/default"
end

#이거가 이제 기본적으로 연결 되어 있는 앱이라고 보면 됨.
#휴.