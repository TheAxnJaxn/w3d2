require_relative 'questions_db'
require_relative 'user'
require_relative 'question'

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

  def self.followers_for_question_id(question_id)
    options = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_follows qf
      JOIN
        users u ON u.id = qf.user_id
      WHERE
        qf.question_id = ?
    SQL
    options.map { |row_hash| User.new(row_hash) }
  end

  def self.followed_questions_for_user_id(user_id)
    options = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows qf
      JOIN
        questions q ON q.id = qf.question_id
      WHERE
        qf.user_id = ?
    SQL
    options.map { |row_hash| Question.new(row_hash) }
  end

  def initialize(options)
    @id, @question_id, @user_id = options['id'], options['question_id'], options['user_id']
  end
end
