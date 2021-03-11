module Grapes
  module V1
    class NewMemoAPI < Grapes::API
      helpers AuthHelpers

      resource :new_memo do 
        #create
        params do 
          requires :question_id, type: Integer 
          requires :content, type: String #text
        end
        post :create do 
          authenticate!
          
          NewMemo.create!({
            user_id: current_user.id,
            question_id: params[:question_id],
            content: params[:content]
          })
          
          return {
            success: true,
            message: "created"
          }
        end
       
        get :list do 
          new_memos = NewMemo.all          
          user_ids = new_memos.map(&:user_id)
          users = User.where(id: user_ids)

          return new_memos.map{|new_memo|
            user = users.find{|user| user.id == new_memo.user_id}

            nick_name = "n/a"
            
            if user 
              nick_name = user.nick_name
            end
            
            {
              new_memo: new_memo,
              nick_name: nick_name,
              gogo: 'home',
            } 
          }
          return array
        end

        route_param :id, type: Integer do 
          #/api/v1/new_memo/#{id}/modify 
          params do 
            requires :content, type: String #content
          end
          put :modify do 
            authenticate!

            memo = NewMemo.find_by(id: params[:id])
            if memo 
              unless current_user.id == memo.user_id
                error!('401 unauthorized', 401) 
              end
              memo.content = content 
              memo.save
            else
              error!('404 not found', 404) 
            end
          end   
=begin

  jwt_token = User.create_jwt_token(1)
  payload = {
    content: 'yaho6'
  }
  conn = Faraday.new(:url => "http://localhost:3000/api/v1/new_memo/6/modify") do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end

  response = conn.put do |req|
    req.headers['Content-Type'] = 'application/json'
    req.headers['Authorization'] = "Bearer " + jwt_token
    req.headers['Accept'] = "application/json"
    req.body = payload.to_json
  end  

  parsed_json = ActiveSupport::JSON.decode(response.body)

=end   
          #/api/v1/new_memo/#{id}/delete 
          delete :delete do 
            memo = NewMemo.find_by(id: params[:id])
            if memo 
              unless current_user.id == memo.user_id
                raise "who are you?"
              end
              memo.delete
            else
            end
          end

          #/api/v1/new_memo/#{id}/like 
          post :like do          
          end

          #/api/v1/new_memo/#{id}/unlike 
          post :unlike do 

          end 
        end
      end
    end
  end
end