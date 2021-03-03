class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.create_jwt_token(id)
    payload = {
      :user_id => id,
      :exp => (Time.now + 1.year).to_i * 1000
    }
    # JWT.decode(token, 's3cr3t', true, algorithm: 'HS256')
    token = JWT.encode payload, ENV["GENERATED_SECRET_KEY"], 'HS256'
    return token
  end

  def self.test
    1.upto(20) do |n|
      User.create!({
        email: SecureRandom.hex(6) + "@gmail.com",
        password: "123123",
        nick_name: SecureRandom.hex(6), 
        birth: 880103,
        timezone: "Asia/Seoul",
        state: "active",
      })
    end

    User.all.each do |user|
      begin
        Memo.create!({
          user_id: user.id,
          content: "asldkfjasldkfj",
          question_id: 1,
          is_public: true
        })
      rescue
      end
    end
  end

  def self.jwt_validate(token)
    if ["", nil, "null", "undefined"].include? token
      return nil
    end

    begin
      decoded_token = JWT.decode token, ENV["GENERATED_SECRET_KEY"], true, { algorithm: 'HS256' }
      user_id = decoded_token[0]["user_id"]
      user = User.find_by(id:user_id)
      return user
    rescue => e
      return nil
    end
  end

  def self.create_or_update_account(params)
    if User.where(nick_name: params[:nick_name]).last
      return {
        message: 'use diffect name',
        success: false,
        user: nil
      }
    end

    success = true
    message = nil    
    user = User.find_by(email: params[:email])
    
    if user
      new_account = false
    else
      new_account = true
    end

    unless user
      user = User.new
      user.email = params[:email]
    end

    #random password required
    if params[:password] != nil
      user.password = params[:password]
    else
      if new_account 
        user.password = SecureRandom.hex(5)
      end
    end

    if params[:nick_name] != nil
      user.nick_name = params[:nick_name]
    end

    if params[:timezone] != nil 
      user.timezone = params[:timezone]
    end

    if params[:birth] != nil
      user.birth = params[:birth]
    end
    
    if new_account
      user.state = "active"
    end

    begin
      user.save!
    rescue => e
      success = false
      message = e.message.to_s
    end
  
    if success
      UserSetting.create!({
        user_id: user.id,
        lang: params[:lang]
      })
      begin
        #send email..?
      rescue
      end
    end

    return {
      message: message,
      success: success,
      user: user,
    }
  end
end
