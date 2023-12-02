#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'

#  only 12 red cubes, 13 green cubes, and 14 blue cubes
#3046


MAX_RED = 12
MAX_GREEN = 13
MAX_BLUE = 14

# class Game
#   def initialize(
#     id:, blue:, green:, red:
#   )
# end

Dir.chdir(File.dirname(__FILE__))
games = File.read('input.txt').split("\n")

valids = []

games.each do |game|
  gameId = game.match(/^Game (\d+):/).captures[0].to_i
  p "=== Game #{gameId} ==="
  num_rounds = game.scan(/;/).count + 1
  rounds = game.match(/^Game \d+: (.*)$/).captures[0].split(';')
  p "rounds: #{rounds}"
  score = rounds.reduce(0) do |sum, round|
    p "- Round: #{round}"
    reds = 0
    greens = 0
    blues = 0
    if round.include? "red"
      reds = round.match(/(\d+) red/).captures[0].to_i
    end
    if round.include? "green"
      greens = round.match(/(\d+) green/).captures[0].to_i
    end
    if round.include? "blue"
      blues = round.match(/(\d+) blue/).captures[0].to_i
    end

    p "- red: #{reds}, green: #{greens}, blue: #{blues} "

    if reds <= MAX_RED && greens <= MAX_GREEN && blues <= MAX_BLUE
      next(sum + 1)
    end
    next(sum)
  end

  if score == num_rounds
    valids << gameId
  end

  # reds = game.scan(/(\d+) red/).flatten.map(&:to_i).reduce(:+)
  # greens = game.scan(/(\d+) green/).flatten.map(&:to_i).reduce(:+)
  # blues = game.scan(/(\d+) blue/).flatten.map(&:to_i).reduce(:+)

  # if reds > MAX_RED || greens > MAX_GREEN || blues > MAX_BLUE
  #   p "Game #{gameId} invalid"
  #   next
  # end

  # valids << gameId
end

p valids
p valids.reduce :+

