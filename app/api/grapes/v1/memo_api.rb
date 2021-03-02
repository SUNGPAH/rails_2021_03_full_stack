module Grapes 
  module V1
		class MemoAPI < Grapes::API
      helpers AuthHelpers

      resource :memo do 
        params do 
          optional :yyyymmdd, type: Integer #20210229
        end
        get do 
          #get the question
          question_tranlsation = nil
          if params[:yyyymmdd]
            question = Question.find_by(date: params[:yyyymmdd])
          else
            #get the question of utc!
            time = Time.now.strftime("%Y%m%d").to_i
            question = Question.find_by(date: time)
            question_id = question.id

            if current_user
              user_setting = UserSetting.where(user_id: current_user.id).last
              question_translation = nil
              if user_setting
                lang = user_setting.lang
                question_translation = QuestionTranslation.where(question_id: question_id).where(lang: lang).last
              end
            end 
          end

          if current_user 
            memo = Memo.where(user_id: current_user.id, question_id: question.id).last
          else
            memo = nil
          end 

          return {
            question: question,
            question_translation: question_tranlsation,
            memo: memo,
            success: true
          }
        end

        params do 
          requires :yyyymmdd, type: Integer #20210229 #like this!
        end
        get :list do 
          if params[:yyyymmdd]
            question = Question.find_by(date: params[:yyyymmdd])
            question_id = question.id
          else
            time = Time.now.strftime("%Y%m%d").to_i
            question = Question.find_by(date: time)

            question_id = question.id
          end

          memos = Memo.where(question_id: question_id).all
          #number of likes should be included in memo
          user_ids = memos.map(&:user_id)
          users = User.select(:id, :nick_name).where(id: user_ids)

          list = memos.map do |memo|
            user = users.find{|user| user.id == memo.user_id}
            memo = memo.as_json
            memo["user"] = user
            memo
          end
        end

        params do 
          requires :yyyymm, type: Integer #202102 #like this!
        end
        get :calendar do 
          authenticate!
          
          #get the questions?
          #or the eailer way to get is.. what the user left during this time.
          yyyy = params[:yyyymm]/100
          mm = params[:yyyymm] - yyyy*100
          
          #timezone?
          #the beginning of month in user's timezone
          time = Time.new(yyyy.to_s, mm.to_s, 3, '0')
          start_time = time.in_time_zone(current_user.timezone).beginning_of_month          
          end_time = start_time + 1.month
          memos = Memo.where(user_id: current_user.id).where("created_at >= ?", start_time).where("created_at < ?", end_time)
          
          created_ats = memos.map{|memo|
            memo.created_at.in_time_zone(current_user.timezone).strftime("%Y%m%d").to_i
          }.uniq

          return {
            success: true,
            created_ats: created_ats
          }
        end

        params do 
          requires :content, type: String
          requires :question_id, type: Integer
          requires :is_public, type: Boolean
        end
        post :create do 
          #user authentication?
          authenticate!

          begin
            Memo.create!({
              user_id: current_user.id,
              content: params[:content],
              question_id: params[:question_id],
              is_public: params[:is_public]
            })
          rescue => e 
            return {
              success: false,
              message: "already submitted"
            }
          end

          return {
            success: true
          }
        end

        params do 
          requires :memo_id, type: Integer
          optional :is_public, type: Boolean
          optional :content, type: String
        end
        post :edit do 
          authenticate!
          memo = Memo.find_by(id: params[:memo_id])

          unless memo
            return {
              success: false,
              message: "not existing"
            }
          end

          if memo.user_id != current_user.id
            return {
              success: false,
              message: "not authorized"
            }
          end

          if params[:is_public] != nil
            memo.is_public = params[:is_public]
          end

          if params[:content] != nil
            memo.content = params[:content] 
          end

          memo.save!
        end

        params do 
          requires :id, type: Integer
        end
        post :delete do 
          authenticate!
          memo = Memo.find_by(id: params[:id])
          unless memo
            return {
              success: false,
              message: "not exist"
            }
          end

          if memo.user_id != current_user.id
            return {
              success: false,
              message: "not autorized"
            }
          end
          memo.delete
        end

        params do 
          requires :id, type: Integer
        end
        post :like do 
          authenticate!

          memo = Memo.find_by(id: params[:id])
          unless memo.is_public 
            return {
              success: false,
              message: "not open to be liked"
            }
          end

          like = Like.where(user_id: current_user.id).where(memo_id: params[:id]).last
          unless like
            Like.create!({
              user_id: current_user.id,
              memo_id: params[:id]
            })
          end

          count = Like.where(memo_id: params[:id]).count

          memo.likes = count
          memo.save!

          return {
            success: true            
          }
        end

        params do 
          requires :target_user_id, type: Integer
        end
        post :follow do 
          authenticate!

          begin
            follow = Follow.create!({
              user_id: current_user.id,
              target_user_id: params[:target_user_id]
            })
          rescue => e
            return {  
              success: false,
              message: e.message.to_s
            }
          end

          return {
            success: true,
          }
        end
      end 
    end
  end
end