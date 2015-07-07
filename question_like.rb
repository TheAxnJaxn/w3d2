require_relative 'questions_db'

class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(id)
    options = QuestionsDatabase.get_first_row(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    QuestionLike.new(options)
  end

  def initialize(options)
    @id, @user_id, @question_id = options['id'], options['user_id'], options['question_id']
  end
end
