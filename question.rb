require_relative 'questions_db'

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
    options = QuestionsDatabase.get_first_row(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    Question.new(options)
  end
end
