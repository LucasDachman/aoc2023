#!/usr/bin/env ruby

#38497
#53941

require 'pry'
require 'pry-nav'

Dir.chdir(File.dirname(__FILE__))
list = File.read('input.txt').split("\n")

# class String
#   def to_i
#       case self
#       when "zero"
#         0
#       when "one"
#         1
#       when "two"
#         2
#       when "three"
#         3
#       when "four"
#         4
#       when "five"
#         5
#       when "six"
#         6
#       when "seven"
#         7
#       when "eight"
#         8
#       when "nine"
#         9
#       else
#         super
#       end
#   end
# end

# p "nine".to_i
# p "9".to_i


list = list.map do |line|
  line = line.scan(/(?=([0-9]|zero|one|two|three|four|five|six|seven|eight|nine))/).flatten

  line = line.map do |item|
    item = item.gsub "zero", "0"
    item = item.gsub "one", "1"
    item = item.gsub "two", "2"
    item = item.gsub "three", "3"
    item = item.gsub "four", "4"
    item = item.gsub "five", "5"
    item = item.gsub "six", "6"
    item = item.gsub "seven", "7"
    item = item.gsub "eight", "8"
    item = item.gsub "nine", "9"
  end


  # line = line.scan(/[0-9]/)

  (line[0]+line[-1]).to_i
end

p list.reduce :+
