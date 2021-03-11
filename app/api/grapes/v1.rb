module Grapes
  module V1
    module AuthHelpers
      extend Grape::DSL::Helpers::BaseHelper
      def current_user
        if @current_user
          return @current_user
        end

        if request.headers["Authorization"]
          jwt_token = request.headers["Authorization"].split(" ").last
          user = User.jwt_validate(jwt_token)
        end
        
        if user && user.state == "deleted"
          return false
        end
    
        return @current_user ||= user
      end
    
      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
    
        beginning_of_day = Time.now.in_time_zone("Asia/Seoul").beginning_of_day
        user_id = current_user.id
    
        begin
          user_agent = request.user_agent.downcase
          is_mobile = (user_agent =~ /mobile|webos|okhttp|cfnetwork/) && (user_agent !~ /ipad/)
        rescue
          is_mobile = false
        end
      end
    end
  end
end

