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

matrix = games.map do |game|
  gameId = game.match(/^Game (\d+):/).captures[0].to_i
  puts "=== Game #{gameId} ==="
  num_rounds = game.scan(/;/).count + 1
  rounds = game.match(/^Game \d+: (.*)$/).captures[0].split(';')
  puts "rounds: #{rounds}"
  maxes = rounds.reduce([0,0,0]) do |maxes, round|
    puts "\t- Round: #{round}"
    if round.include? "red"
      reds = round.match(/(\d+) red/).captures[0].to_i
      maxes[0] = reds if reds > maxes[0]
    end
    if round.include? "green"
      greens = round.match(/(\d+) green/).captures[0].to_i
      maxes[1] = greens if greens > maxes[1]
    end
    if round.include? "blue"
      blues = round.match(/(\d+) blue/).captures[0].to_i
      maxes[2] = blues if blues > maxes[2]
    end

    puts "\tred: #{reds}, green: #{greens}, blue: #{blues} "

    next maxes
  end

  maxes.reduce :*
end

p matrix.reduce :+
# p valids.reduce :+

