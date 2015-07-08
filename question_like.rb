require_relative 'questions_db'
require_relative 'user'
require_relative 'question'

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

  def self.likers_for_question_id(question_id)
    options = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users u
      JOIN
        question_likes ql ON u.id = ql.user_id
      WHERE
        ql.question_id = ?
    SQL

    options.map { |row_hash| User.new(row_hash) }
  end

  def self.num_likes_for_question_id(question_id)
    options = QuestionsDatabase.get_first_row(<<-SQL, question_id)
      SELECT
        COUNT(*) a
      FROM
        question_likes
      WHERE
        question_likes.question_id = ?
      GROUP BY
        question_id
    SQL
    options["a"]
  end

  def self.liked_questions_for_user_id(user_id)
    options = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN (
        SELECT
          ql.question_id
        FROM
          question_likes ql
        WHERE
          ql.user_id = ?
        ) liked_questions ON liked_questions.question_id = questions.id
    SQL
    options.map { |row_hash| Question.new(row_hash)}

  end

  def initialize(options)
    @id, @user_id, @question_id = options['id'], options['user_id'], options['question_id']
  end

end
