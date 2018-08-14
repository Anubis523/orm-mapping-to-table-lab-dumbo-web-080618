require 'pry'
class Student
  attr_accessor :name, :grade
  attr_reader  :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  def initialize (name, grade, id: nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.create(hash)
    student = Student.new(hash[:name], hash[:grade])
    student.save
    student

  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?,?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    sql_student = <<-SQL
      SELECT * FROM students ORDER BY id DESC LIMIT 1
    SQL

    info = DB[:conn].execute(sql_student)
    # binding.pry
    @id = info[0][0]
  end

end
