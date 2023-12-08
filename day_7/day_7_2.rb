#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'

Dir.chdir(File.dirname(__FILE__))
input = File.read("#{ARGV[0] || "example"}.txt").strip

hand_strs = input.split("\n")

class Hand
  include Comparable
  attr_accessor :str, :bid

  def initialize(str, bid)
    @str = str
    @bid = bid
  end

  def rank
    raise "Not Implemented"
  end

  def <=>(other)
    if self.rank == other.rank
      (0...5).each do |i|
        next if self.str[i] == other.str[i]
        return Hand.cards.find_index {|c| c == other.str[i]} - Hand.cards.find_index {|c| c == @str[i]}
      end
    end
    other.rank - self.rank
  end

  def inspect
    "#{@str}\t#{self.class.name}"
  end

  def to_s
    "#{@str}\t#{self.class.name}"
  end

  def self.matches_for(str)
    cards.reduce({}) do |acc, c|
      acc[c] = str.scan(c).length
      acc
    end
  end

  def self.parse(line)
    str, bid = line.split(" ")
    classes = [FiveOfAKind, FourOfAKind, FullHouse, ThreeOfAKind, TwoPair, OnePair, HighCard]
    classes.find {|c| c.applies_to? str}.new(str, bid.to_i)
  end

  def self.cards
    ['J', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A']
  end
end

class HighCard < Hand
  def rank
    1
  end
  def self.applies_to?(str)
    true
  end
end

class OnePair < Hand
  def rank
    2
  end
  def self.applies_to?(str)
    matches = matches_for str
    matches.any?(2) ||
    matches.except('J').values.any? {|m| m + matches['J'] == 2}
  end
end

class TwoPair < Hand
  def rank
    3
  end
  def self.applies_to?(str)
    matches = matches_for str
    str_sorted = str.split("").sort.join
    !!str_sorted.match(/(.)\1.*(.)\2/) ||
      (!!str_sorted.match(/(.)\1/) && matches['J'] == 1) ||
      matches['J'] == 2
  end
end

class ThreeOfAKind < Hand
  def rank
    4
  end
  def self.applies_to?(str)
    matches = matches_for str
    matches.any?(3) ||
    matches.except('J').values.any? {|m| m + matches['J'] == 3}
  end
end

class FullHouse < Hand
  def rank
    5
  end
  def self.applies_to?(str)
    j_count = str.scan('J').count
    str = str.split("").sort.join
    !!str.match(/(.)\1\1(.)\2/) ||
    !!str.match(/(.)\1(.)\2\2/) ||
    (str.match(/(.)\1.*(.)\2/) &&  j_count == 1)
  end
end

class FourOfAKind < Hand
  def rank
    6
  end
  def self.applies_to?(str)
    matches = matches_for str
    matches.any?(4) ||
    matches.except('J').values.any? {|m| m + matches['J'] == 4}
  end
end

class FiveOfAKind < Hand
  def rank
    7
  end
  def self.applies_to?(str)
    matches = matches_for str
    matches.values.any?(5) ||
    matches.except('J').values.any? {|m| m + matches['J'] == 5}
  end
end

hands = hand_strs.map do |line|
  Hand.parse(line)
end

puts hands.join("\n")

hands.sort!.reverse!

winnings = hands.map.with_index do |hand, i|
  hand.bid * (i + 1)
end

p winnings.sum

# J448Q
#TT889   OnePair

#248643063
#248781813
