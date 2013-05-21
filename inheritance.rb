class Employee
  attr_accessor :boss
  attr_reader :name, :title, :salary

  def initialize(name, title, salary)
    @name, @title, @salary = name, title, salary
  end

  def calculate_bonus(multiplier)
    @salary * multiplier
  end
end

class Manager < Employee
  attr_reader :employees
  def initialize(employees, name, title, salary)
    super(name, title, salary)
    @employees = employees
  end

  def assign_employee(employee)
    @employees << employee
    employee.boss = self
  end

  def calculate_bonus(multiplier)
    bonus = 0
    @employees.each do |employee|
      if employee.is_a?(Employee)
        bonus += super(multiplier)
      else
        bonus += employee.calculate_bonus(multiplier)
      end
    end
    bonus
  end
end

employee = Employee.new("bob", "worker", 20)
employee2 = Manager.new([], "bob", "boss", 50)
boss = Manager.new([], "jim", "boss", 50)

employee2.assign_employee(employee)
boss.assign_employee(employee2)

p boss.calculate_bonus(1.5)




