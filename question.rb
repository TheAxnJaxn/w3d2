require_relative 'questions_db'
require_relative 'reply'
require_relative 'question_follow'

class Question
  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    options = QuestionsDatabase.get_first_row(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    Question.new(options)
  end

  def initialize(options)
    @id, @title, @body, @author_id = options['id'], options['title'], options['body'], options['author_id']
  end

  def self.find_by_author_id(author_id)
    options = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    options.map { |row_hash| Question.new(row_hash) }
  end

  def author
    author_id = @author_id
    options = QuestionsDatabase.get_first_row(<<-SQL, author_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(options)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end
end
