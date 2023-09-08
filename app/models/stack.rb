require 'rgl/adjacency'
require 'rgl/dot'

class Stack
  include ActiveModel::Model

  attr_accessor :name, :orders

  def self.base
    new(
      name: 'base',
      orders: [
        Order.new(0, Project.new('consul')),
        Order.new(1, Project.new('vault')),
        Order.new(2, Project.new('config'))
      ]
    )
  end

  def self.lead
    new(
      name: 'lead',
      orders: [
        Order.new(0, Project.new('lead')),
        Order.new(0, Project.new('cm')),
        Order.new(0, Project.new('ldir')),
        Order.new(0, Project.new('expert'))
      ]
    )
  end

  def self.tin
    new(
      name: 'tin',
      orders: [
        Order.new(1, Project.new('tin')),
        Order.new(0, Project.new('cm')),
        Order.new(0, Project.new('iron')),
        Order.new(0, Project.new('expert'))
      ]
    )
  end

  def self.zinc
    new(
      name: 'zinc',
      orders: [
        Order.new(1, Project.new('zinc')),
        Order.new(2, Project.new('cm')),
        Order.new(0, Project.new('ldir')),
        Order.new(0, Project.new('copper'))
      ]
    )
  end

  def nodes
    groups = orders.sort_by(&:order).group_by(&:order)
    groups.values.each_cons(2).map { |group| group[0].product(group[1]) }.flatten.map(&:project)
  end

  def graph
    graph = RGL::DirectedAdjacencyGraph[*nodes]
    graph.write_to_graphic_file('jpg')
    `open graph.jpg`
    graph
  end
end
