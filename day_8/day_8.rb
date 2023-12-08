#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'

Dir.chdir(File.dirname(__FILE__))
input = File.read("#{ARGV[0] || "example"}.txt").strip

class Node
  attr_accessor :name, :l, :r
  def initialize(name:, l:, r:)
    @name = name
    @l = l
    @r = r
  end

  def self.parse(line)
    capts = line.match(/^(?<name>\w\w\w) = \((?<l>\w\w\w), (?<r>\w\w\w)/).named_captures
    Node.new(name: capts["name"].to_sym, l: capts["l"].to_sym, r: capts["r"].to_sym)
  end
end

class Map
  attr_accessor :seq, :nodes
  def initialize(seq:, node_list: [])
    @seq = seq
    @nodes = node_list.reduce({}) do |acc, node|
      acc[node.name] = node
      acc
    end
  end

  def run
    count = 0
    node = @nodes[:AAA]
    while node.name != :ZZZ
      next_sym = node.send(@seq[count % @seq.size])
      node = @nodes[next_sym]
      count += 1
    end
    count
  end

  def self.parse(input)
    seq = input.match(/.*/)[0].split("").map {|c| c.downcase.to_sym}
    nodes = input.split("\n").drop(2).map {|line| Node.parse(line)}
    Map.new(seq: seq, node_list: nodes)
  end
end

map = Map.parse(input)
p map.nodes
p map.run
