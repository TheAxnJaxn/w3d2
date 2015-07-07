require_relative 'questions_db'
require_relative 'user'
require_relative 'question'

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
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def self.find_by_user_id(user_id)
    options = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    options.map { |row_hash| Reply.new(row_hash) }
  end

  def self.find_by_question_id(question_id)
    options = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    options.map { |row_hash| Reply.new(row_hash) }
  end

  def author
    user_id = @user_id
    options = QuestionsDatabase.get_first_row(<<-SQL, user_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(options)
  end

  def question
    question_id = @question_id
    options = QuestionsDatabase.get_first_row(<<-SQL, question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    Question.new(options)
  end

  def parent_reply
    parent_reply_id = @parent_reply_id
    options = QuestionsDatabase.get_first_row(<<-SQL, parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    raise "No parent reply!" if options.nil?
    Reply.new(options)
  end

  def child_replies
    id = @id
    options = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL
    raise "No children replies!" if options.empty?
    options.map { |row_hash| Reply.new(row_hash) }
  end
end
