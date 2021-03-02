module Grapes 
  module V1
		class UserSettingAPI < Grapes::API
      helpers AuthHelpers
      resource :user_setting do 
        params do 
          optional :lang, type: String #en, kor, jap, chi.. 
          optional :is_reminder_on, type: Boolean
          optional :is_public, type: Boolean 
          optional :alarm_time_int, type: Integer
        end
        post :update do 
          authenticate!
          user_setting = UserSetting.where(user_id: current_user.id).last

          if user_setting
            if params[:lang] != nil
              user_setting.lang = params[:lang]
            end

            if params[:is_reminder_on] != nil
              user_setting.is_reminder_on = params[:is_reminder_on]
            end

            if params[:is_public] != nil 
              user_setting.is_public = params[:is_public]
            end

            if params[:alarm_time_int] != nil
              user_setting.alarm_time_int = params[:alarm_time_int]
            end
            
            begin
              user_setting.save!
            rescue => e
              return {
                success: false,
                message: e.message.to_s
              }
            end

            return {
              success: true,
              message: "modified",
            }
          end

          begin
            params[:user_id] = current_user.id
            user_setting = UserSetting.create!(params)
            return {
              success: true 
            }
          rescue => e
            return {
              success:false,
              message: e.message.to_s
            }
          end
        end
      end
    end
  end
end