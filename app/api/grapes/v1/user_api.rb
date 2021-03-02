module Grapes 
  module V1
		class UserAPI < Grapes::API
      helpers AuthHelpers
      resource :user do 
        params do 
          requires :email, type: String
          optional :password, type: String
          optional :nick_name, type: String
          optional :birth, type: Integer
          optional :lang, type: String, values: ["eng", "kor", "jap", "chi"]
        end
        post :signup do 
          result = User.create_or_update_account(params)
          return result
        end

        params do 
          #how to authenticate?
          requires :email, type: String
          requires :password, type: String
        end
        post :authenticate do 
          user = User.where(email: params[:email]).last
          if user
            if user.valid_password?(params[:password])
              jwt_token = User.create_jwt_token(user.id)
              return {
                success: true,
                jwt_token: jwt_token
              }
            else
              return {
                success: false,
                message: "password is wrong"
              }
            end  
          else
            return {
              success: false,
              message: "user not found"
            }          
          end
        end

        params do 
          optional :nick_name, type: String
          optional :birth, type: Integer
        end
        post :edit do 
          authenticate!

          #nick name same..? no?
          if params[:nick_name] != nil 
            current_user.nick_name = params[:nick_name]
          end

          if params[:birth] != nil 
            current_user.birth = params[:birth]
          end

          current_user.save!
          return {
            success: true
          }
        end

        namespace :password do 
          params do 
            requires :email, type: String
          end
          post :reset do 
            user = User.find_by(email: params[:email])
            unless user
              return {
                success: false,
                message: "account not found"
              }
            end

            payload = {
              :user_id => user.id,
              :exp => (Time.now + 30.minutes).to_i
            }

            token = JWT.encode payload, ENV["GENERATED_SECRET_KEY"], 'HS256'
            user.reset_password_token = token
            user.reset_password_sent_at = Time.now
            user.save

            return {
              success: true,
              reset_password_token: token
            }         
          end

          params do 
            requires :reset_password_token, type: String
          end
          get :validate_token do 
            decoded_token = JWT.decode params[:reset_password_token], ENV["GENERATED_SECRET_KEY"], true, { algorithm: 'HS256' }
            user_id = decoded_token[0]["user_id"]
            user = User.find_by(id:user_id)
            exp = decoded_token[0]["exp"]

            unless Time.now.to_i < exp
              return {
                success: false,
                message: "Token has been expired. Try again"
              }
            end
            
            return {
              success: true,
              # jwt_token: User.create_jwt_token(user_id),
              message: 'allowed to edit'
            }
          end

          desc "reset token is required in both cases (get grants, database update)"
          params do 
            requires :reset_password_token, type: String
            requires :email, type: String
            requires :new_password, type: String
          end
          post :update do
            user = User.where(email: params[:email]).last
            
            decoded_token = JWT.decode params[:reset_password_token], ENV["GENERATED_SECRET_KEY"], true, { algorithm: 'HS256' }
            user_id = decoded_token[0]["user_id"]
            user = User.find_by(id:user_id)
            exp = decoded_token[0]["exp"]

            unless Time.now.to_i < exp
              return {
                success: false,
                message: "Token has been expired. Try again"
              }
            end
          
            if user
              user.password = params[:new_password]
              begin
                user.save!
                return {
                  success: true,
                  jwt_token: User.create_jwt_token(user.id)
                }
              rescue => e
                return {
                  success: false,
                  message: e.message.to_s
                }
              end
            else
              return {
                success: false,
                message: "user not found"
              }          
            end
          end
        end
      end
    end
  end
end
