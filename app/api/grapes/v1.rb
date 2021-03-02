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
    
        #여기서 레코드를 만들어 보자.
        #api 분석을 위해서 간단히 해볼 수 있는 것 부터.
        beginning_of_day = Time.now.in_time_zone("Asia/Seoul").beginning_of_day #구지 이거로 되어 있나 근데.
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

