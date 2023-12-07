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


  def self.matches_for(str)
    cards.map do |c|
      {card: c, count: str.scan(c).length}
    end
  end

  def self.parse(line)
    str, bid = line.split(" ")
    classes = [FiveOfAKind, FourOfAKind, FullHouse, ThreeOfAKind, TwoPair, OnePair, HighCard]
    classes.find {|c| c.applies_to? str}.new(str, bid.to_i)
  end

  def self.cards
    ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']
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
    pairs = matches.filter {|m| m[:count] == 2}
    pairs.length == 1
  end
end

class TwoPair < Hand
  def rank
    3
  end
  def self.applies_to?(str)
    matches = matches_for str
    pairs = matches.filter {|m| m[:count] == 2}
    pairs.length == 2
  end
end

class ThreeOfAKind < Hand
  def rank
    4
  end
  def self.applies_to?(str)
    matches = matches_for str
    triples = matches.filter {|m| m[:count] == 3}
    triples.length > 0
  end
end

class FullHouse < Hand
  def rank
    5
  end
  def self.applies_to?(str)
    matches = matches_for str
    triples = matches.filter {|m| m[:count] == 3}
    pairs = matches.filter {|m| m[:count] == 2}
    triples.length == 1 && pairs.length == 1
  end
end

class FourOfAKind < Hand
  def rank
    6
  end
  def self.applies_to?(str)
    matches = matches_for str
    matches.any? {|m| m[:count] == 4}
  end
end

class FiveOfAKind < Hand
  def rank
    7
  end
  def self.applies_to?(str)
    matches = matches_for str
    matches.any? {|m| m[:count] == 5}
  end
end

hands = hand_strs.map do |line|
  Hand.parse(line)
end

hands.sort!.reverse!

winnings = hands.map.with_index do |hand, i|
  hand.bid * (i + 1)
end

p winnings.sum
