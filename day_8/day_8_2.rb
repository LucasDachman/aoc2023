#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'


class Node
  attr_accessor :name, :l, :r
  def initialize(name:, l:, r:)
    @name = name
    @l = l
    @r = r
  end

  def inspect
    "{#{@name}, #{@l}, #{r}}"
  end

  def to_s
    inspect
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
    curr_nodes = @nodes.values.filter {|n| n.name.end_with? "A"}
    # binding.pry
    while curr_nodes.any? {|node| !node.name.end_with? "Z"}
      meth_sym = @seq[count % @seq.size]
      curr_nodes.map! {|n| @nodes[n.send(meth_sym)]}
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

class MapOpt < Map
  def run_one(node)
    count = 0
    loop do
      @seq.each do |meth_sym|
        node = @nodes[node.send(meth_sym)]
        count += 1
        return count if node.name.end_with? "Z"
      end
    end
  end

  def run
    count = 0
    curr_nodes = @nodes.values.filter {|n| n.name.end_with? "A"}
    # binding.pry
    multiples = curr_nodes.map {|n| run_one(n)}
    multiples.reduce(1, :lcm)
  end

  def self.parse(input)
    seq = input.match(/.*/)[0].split("").map {|c| c.downcase.to_sym}
    nodes = input.split("\n").drop(2).map {|line| Node.parse(line)}
    MapOpt.new(seq: seq, node_list: nodes)
  end
end

class Part2
  def initialize(filename)
    Dir.chdir(File.dirname(__FILE__))
    @input = File.read("#{filename}.txt").strip
  end
  def brute
    map = Map.parse(@input)
    map.run
  end

  def opt
    # p map.nodes
    map = MapOpt.parse(@input)
    map.run
  end
end

p Part2.new(ARGV[0] || "example").opt
