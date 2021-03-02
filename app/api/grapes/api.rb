module Grapes
    class API < Grape::API
      format :json
      prefix :api
      version 'v1', :path

      mount Grapes::V1::MemoAPI
      mount Grapes::V1::UserSettingAPI
      mount Grapes::V1::UserAPI
      mount Grapes::V1::Movies
      mount Grapes::V2::Something
    end
  end