require_relative 'questions_db'

class Reply
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def self.find_by_id(id)
    options = QuestionsDatabase.get_first_row(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    Reply.new(options)
  end

  def initialize(options)
    @id, @question_id, @parent_reply_id, @user_id, @body = options['id'], options['question_id'], options['parent_reply_id'], options['user_id'], options['body']
  end

  def self.find_by_user_id(user_id)
  end
end
