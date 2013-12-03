#Palindromes
#Problem Statement: Given a sentence, return true if the sentence is a palindrome.

#My Code
def palindrome?(sentence)
  is_palindrome = true
  letters = sentence.gsub(' ', '').downcase.split('')
  letters.each_index do |i|
    is_palindrome = is_palindrome && (letters[i] == letters[-(i+1)])
  end
  return is_palindrome
end

#Official Solution
def palindrome?(sentence)
  downcase_stripped_sentence = sentence.downcase.gsub(" ", "")
  downcase_stripped_sentence  ==  downcase_stripped_sentence.reverse
end

# -----------
#Sum of Cubes
#Problem Statement: Compute the sum of cubes for a given range a through b. 

#My Code
def sum_of_cubes(a, b)
  numbers = (a..b).to_a
  numbers.map! { |num| num * num * num }
  sum = 0
  numbers.each do |num|
    sum += num
  end
  return sum
end

#Offical Solution
def sum_of_cubes(a, b)
  (a..b).inject(0) { |sum, x| sum += (x*x*x) }
end

#--------------------
#Non-Duplicate Values
#Problem Statement: Given an Array, return the elements that are present exactly once in the array.

#My Code
def non_duplicated_values(values)
  duplicates = values.find_all { |item| values.count(item) > 1 }.uniq
  duplicates.each do |item|
    values.delete(item)
  end
  return values
end

#Official Solution
def non_duplicated_values(values)
  values.find_all { |x| values.count(x) == 1 }
end

#--------------
#Number Shuffle
#Problem Statement: Given a 3 or 4 digit number with distinct digits, return a sorted array of
# all the unique numbers than can be formed with those digits. 

#My Code
def number_shuffle(number)
  nums = "#{number}".split('')
  unique_nums = []
  (1..nums.length).inject(:*).times do
    loop do
      break if !unique_nums.include?(nums.shuffle!.join.to_i)
    end
    unique_nums << nums.join.to_i
  end
    return unique_nums.sort
end

#Official Solution
def number_shuffle(number)
  no_of_combinations = number.to_s.size == 3 ? 6 : 24
  digits = number.to_s.split(//)
  combinations = []
  combinations << digits.shuffle.join.to_i while combinations.uniq.size!=no_of_combinations
  combinations.uniq.sort
end

#---------------
#Kaprekar Number
#Problem Statement: A Kaprekar number k with n-digits, if you square it and 
# add the right n digits to the left n or n-1 digits, the resultant sum is k
# Find if a number is a Kaprekar number

#My Code
def kaprekar?(k)
  digits = (k*k).to_s.split(//)
  border = digits.length - k.to_s.length
  return k == digits[0..(border-1)].join.to_i + \
    digits[border..(digits.length-1)].join.to_i
end

#Official Solution
def kaprekar?(k)
  no_of_digits = k.to_s.size
  square = (k ** 2).to_s
  
  second_half = square[-no_of_digits..-1]
  first_half = square.size.even? ? square[0..no_of_digits-1] : square[0..no_of_digits-2]
  
  k == first_half.to_i + second_half.to_i
end

#----------
#Restaurant
#Problem Statement: A restaurant has incoming orders for which you need to
# compute the costs based on the menu.

#My Code
class Restaurant
  def initialize(menu)
    @menu = menu
  end

  def cost(*orders)
    total = 0
    orders.each do |order|
      items = order.keys
      total += items.inject(0) { |subtotal, item| subtotal += @menu[item] * order[item] }
    end
    total
  end
end

#Official Solution
class Restaurant
  def initialize(menu)
    @menu = menu
  end

  def cost(*orders)
    orders.inject(0) do |total_cost, order|
      total_cost + order.keys.inject(0) {|cost, key| cost + @menu[key]*order[key] }
    end
  end
end
