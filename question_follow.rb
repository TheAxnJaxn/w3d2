require_relative 'questions_db'

class QuestionFollow
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    options = QuestionsDatabase.get_first_row(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    QuestionFollow.new(options)
  end

  def initialize(options)
    @id, @question_id, @user_id = options['id'], options['question_id'], options['user_id']
  end
end
