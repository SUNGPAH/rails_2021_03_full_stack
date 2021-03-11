class Question < ApplicationRecord
  def self.init
    number = 20210311
    1.upto(10) do |n|
      Question.create!({
        content: "gogogogogo question!",
        date: number + n      
      })  
    end
  end
end
