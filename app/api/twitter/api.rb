module Twitter
    class API < Grape::API
      version 'v1', using: :header, vendor: 'twitter'
      format :json
      prefix :api
  
    #   helpers do
    #     def current_user
    #       @current_user ||= User.authorize!(env)
    #     end
  
    #     def authenticate!
    #       error!('401 Unauthorized', 401) unless current_user
    #     end
    #   end
      
      resource :statuses do
        desc 'Return a public timeline.'
        get :public_timeline do
        #   Status.limit(20)
        end
  
        desc 'Return a personal timeline.'
        get :home_timeline do
          authenticate!
          current_user.statuses.limit(20)
        end
      end
    end
  end