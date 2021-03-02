module TestModule
  def self.request(host, url, jwt_token, payload, method:"post")
    conn = Faraday.new(:url => "#{host}#{url}") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    
    if method == "post"
      response = conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer " + jwt_token
        req.headers['Accept'] = "application/json"
        req.body = payload.to_json
      end  
    else
      response = conn.get do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer " + jwt_token
        req.headers['Accept'] = "application/json"
        req.body = payload.to_json
      end  
    end
    parsed_json = ActiveSupport::JSON.decode(response.body)
    return parsed_json
  end

  def self.create_memo_default(user_id:, question_id:)
    jwt_token = User.create_jwt_token(user_id)
    host = "http://localhost:3000"
    url = "/api/v1/memo/create"

    payload = {
      content: "good man",
      question_id: question_id,
      is_public: true
    }
    result = TestModule::request(host, url, jwt_token, payload)
  end

  def memo
    user_id = 1 
    jwt_token = User.create_jwt_token(user_id)
    host = "http://localhost:3000"

    url = "/api/v1/memo/create"
    payload = {
      content: "good man",
      question_id: 1,
      is_public: false
    }
    result = TestModule::request(host, url, jwt_token, payload)

    if result["success"]
      raise "error. Apply should be prevented"
    end

    #modify
    user_id = 1
    jwt_token = User.create_jwt_token(user_id)
    url = "/api/v1/memo/edit"
    payload = {
      memo_id: Memo.last.id,
      content: "good man yo",
      is_public: false
    }
    result = TestModule::request(host, url, jwt_token, payload)

    #modify -2 # is_public
    payload = {
      memo_id: Memo.last.id,
      content: "good man yo",
      is_public: true
    }
    result = TestModule::request(host, url, jwt_token, payload)

    #delete
    url = "/api/v1/memo/delete"
    id = Memo.last.id
    payload = {
      id: id,
    }
    result = TestModule::request(host, url, jwt_token, payload)
    memo = Memo.find_by(id: id)
    if memo
      raise "error - memo not deleted"
    end

    #in order to test below, we need to execute creation of new record
    url = "/api/v1/memo/create"
    payload = {
      content: "good man",
      question_id: 1,
      is_public: false
    }
    #of other person
    result = TestModule::request(host, url, User.create_jwt_token(2), payload)
    #delete - not authorized.
    url = "/api/v1/memo/delete"
    memo = Memo.where.not(user_id: user_id).last
    id = memo.id

    payload = {
      id: id,
    }
    result = TestModule::request(host, url, jwt_token, payload)
    if result["success"]
      raise "error - should have been unauthorized"
    end
    
    #get 
    url = "/api/v1/memo"
    result = TestModule::request(host, url, jwt_token, nil, method:"get")
    unless result["success"]
      raise "error - should have been unauthorized"
    end

    #code자체도, 순서대로 작성이 되어 있으면 안 헷갈릴텐데
    #calendar
    # let's create some..
    TestModule::create_memo_default(user_id: user_id, question_id: 1)

    user_id = 1 
    jwt_token = User.create_jwt_token(user_id)
    host = "http://localhost:3000"
    url = "/api/v1/memo/calendar?yyyymm=#{202102}"
    result = TestModule::request(host, url, jwt_token, nil, method:"get")
    if result["success"]
      raise "error - should have been unauthorized"
    end

    #like - likable case
    user_id = 1 
    jwt_token = User.create_jwt_token(user_id)
    host = "http://localhost:3000"
    url = "/api/v1/memo/like"

    id = Memo.where(is_public: true).last.id

    payload = {
      id: id
    }
    result = TestModule::request(host, url, jwt_token, payload)
    unless result["success"]
      raise "issue on like"
    end

    #like - unlikable case
    user_id = 1 
    jwt_token = User.create_jwt_token(user_id)
    host = "http://localhost:3000"
    url = "/api/v1/memo/like"

    id = Memo.where(is_public: false).last.id

    payload = {
      id: id
    }
    result = TestModule::request(host, url, jwt_token, payload)
    if result["success"]
      raise "issue on like..#{result["message"]}"
    end

    #follow
    user_id = 1 
    jwt_token = User.create_jwt_token(user_id)
    url = "/api/v1/memo/follow"

    payload = {
      target_user_id: User.where.not(id: user_id).last.id
    }
    result = TestModule::request(host, url, jwt_token, payload)
    unless result["success"]
      raise "follow fails"
    end

    #user_setting: create
    user_id = 1 
    jwt_token = User.create_jwt_token(user_id)
    host = "http://localhost:3000"
    url = "/api/v1/user_setting/update"

    payload = {
      lang: 'kor',
      is_reminder_on: true,
      is_public: true,
      alarm_time_int: 15
    }
    result = TestModule::request(host, url, jwt_token, payload)
    unless result["success"]
      raise "follow fails"
    end

    #user_setting: modify
    user_id = 1 
    jwt_token = User.create_jwt_token(user_id)
    host = "http://localhost:3000"
    url = "/api/v1/user_setting/update"

    payload = {
      lang: 'kor',
      is_reminder_on: true,
      is_public: true,
      alarm_time_int: 15
    }
    result = TestModule::request(host, url, jwt_token, payload)
    unless result["success"]
      raise "follow fails"
    end

    #user info modify
    user_id = 1 
    jwt_token = User.create_jwt_token(user_id)
    host = "http://localhost:3000"
    url = "/api/v1/user/edit"

    payload = {
      nick_name: 'good nick_name',
      birth: 19880104
    }
    result = TestModule::request(host, url, jwt_token, payload)
    unless result["success"]
      raise "follow fails"
    end

    # user create - valid signup
    host = "http://localhost:3000"
    url = "/api/v1/user/signup"

    payload = {
      email: "asdff#{SecureRandom.hex(6)}@gmail.com",
      password: 19880104,
      nick_name: "nick namess",
      birth: 880103,
      lang: 'kor'
    }

    result = TestModule::request(host, url, "", payload)
    unless result["success"]
      raise "signup error"
    end

    # user create - nick name duplication
    host = "http://localhost:3000"
    url = "/api/v1/user/signup"

    payload = {
      email: 'asdff@gmail.com',
      password: 19880104,
      nick_name: "good",
      birth: 880103
    }

    result = TestModule::request(host, url, "", payload)
    if result["success"]
      raise "signup error"
    end

    #authenticate test
    host = "http://localhost:3000"
    url = "/api/v1/user/authenticate"

    payload = {
      email: 'asdff@gmail.com',
      password: '123123',
    }

    result = TestModule::request(host, url, "", payload, method: "post")
    unless result["jwt_token"]
      raise "signin error"
    end

    #password api - 1 - whether he/she owns the account
    host = "http://localhost:3000"
    url = "/api/v1/user/password/reset"
    email = "asdff@gmail.com"
    payload = {
      email: email,
    }
    result = TestModule::request(host, url, "", payload, method: "post")
    
    unless result["success"]
      raise "error - password reset not viable"
    end

    #password api - 2 
    host = "http://localhost:3000"
    url = "/api/v1/user/password/validate_token?reset_password_token=#{User.find_by(email:email).reset_password_token}"

    payload = {
      email: email,
    }
    result = TestModule::request(host, url, "", payload, method: "get")
    
    unless result["success"]
      raise "error - password reset not viable -2"
    end

    #password api - 3
    host = "http://localhost:3000"
    url = "/api/v1/user/password/update"

    payload = {
      email: email,
      reset_password_token: User.find_by(email:email).reset_password_token,
      new_password: '123123'
    }
    result = TestModule::request(host, url, "", payload, method: "post")
    
    unless result["success"]
      raise "error - password reset not viable -3"
    end
  end
end