require 'rgl/adjacency'
require 'rgl/dot'

class Stack
  include ActiveModel::Model

  attr_accessor :name, :orders, :stacks

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

  def self.db
    new(
      name: 'db',
      orders: [
        Order.new(0, 'db')
      ]
    ).need(base)
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
    ).need(db)
  end

  def self.tin
    new(
      name: 'tin',
      orders: [
        Order.new(1, Project.new('tin')),
        Order.new(1, Project.new('cm')),
        Order.new(0, Project.new('iron')),
        Order.new(0, Project.new('expert'))
      ]
    ).need(db)
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
    ).need(db)
  end

  def self.copper
    new(
      name: 'copper',
      orders: [
        Order.new(2, Project.new('cm')),
        Order.new(0, Project.new('ldir')),
        Order.new(0, Project.new('copper'))
      ]
    ).need(db)
  end

  def self.atom
    new(
      name: 'atom',
      orders: [
        Order.new(2, Project.new('proton')),
        Order.new(0, Project.new('neutron')),
        Order.new(0, Project.new('electron'))
      ]
    )
  end

  def self.pewter
    new(
      name: 'pewter',
      orders: [
        Order.new(2, Project.new('pewter')),
        Order.new(0, Project.new('tin')),
        Order.new(0, Project.new('copper'))
      ]
    ).need([atom])
  end

  def need(stacks)
    @needs = Array(stacks)
    self
  end

  def dependencies
    return [] if @needs.blank?

    @needs.first.grouped_orders
  end

  def grouped_orders
    dependencies + orders.sort_by(&:order).group_by(&:order).values
  end

  def nodes
    grouped_orders.each_cons(2).map { |pair| pair[0].product(pair[1]) }.flatten.map(&:project)
  end

  def graph
    graph = RGL::DirectedAdjacencyGraph[*nodes]
    graph.write_to_graphic_file('jpg')
    `open graph.jpg`
    graph
  end
end
