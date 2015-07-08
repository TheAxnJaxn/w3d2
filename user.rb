require_relative 'questions_db'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow'

class User
  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    options = QuestionsDatabase.get_first_row(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(options)
  end

  def self.find_by_name(fname, lname)
    options = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    options.map { |row_hash| User.new(row_hash) }
  end

  def initialize(options)
    @id, @fname, @lname = options['id'], options['fname'], options['lname']
  end

  def save
    raise 'already in database!' unless self.id.nil?

    fname, lname = @fname, @lname
    QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

end
