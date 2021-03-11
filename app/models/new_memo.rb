class NewMemo < ApplicationRecord

  def create_record(content, user_id, question_id)
    NewMemo.create!({
      user_id: user_id,
      content: content,
      question_id: question_id
    })
  end

  def test_where(user_id, question_id)
    NewMemo.where(user_id: user_id, question_id: question_id)    
  end

  def test_find_by(user_id)
    NewMemo.find_by(user_id: user_id) #return the first element.
  end

  def test_find(id)
    NewMemo.find(id)
  end

  def modify(id, content)
    new_memo = NewMemo.find_by(id: id) 
    if new_memo
      new_memo.content = content
      # new_memo.user_id = 111
      new_memo.save  
    else
      puts 'so sad'
    end
  end

  def modify(id, content)
    new_memo = NewMemo.find_by(id: id) 

    unless new_memo 
      return
    end 

    new_memo.content = content
    new_memo.save  
  end

  # def delete(id)
  #   new_memo = NewMemo.find_by(id:id)
  #   unless new_memo
  #     return
  #   end

  #   new_memo.delete
  # end

  def get_length 
    NewMemo.count
    #NewMemo.all.length
  end

  def update_all_test
    #..#
  end
  #where
  #find_by
  #find  

end
