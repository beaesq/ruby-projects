# lib/calculator.rb
# frozen_string_literal: true

# calc
class Calculator
  def add(*nums)
    nums.reduce(0) { |sum, num| sum + num }
  end

  def multiply(*nums)
    nums.reduce(1) { |product, num| product * num }
  end

  def subtract(num1, *nums)
    nums.reduce(num1) { |diff, num| diff - num }
  end

  def divide(num1, *nums)
    result = nums.reduce(num1.to_f) { |quotient, num| quotient.to_f / num }
    result % 1 != 0 ? result : result.to_i
  end
end
