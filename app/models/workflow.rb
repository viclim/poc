require 'rgl/adjacency'
require 'rgl/dot'

class Workflow
  include ActiveModel::Model

  def stacks
    [Stack.lead, Stack.tin, Stack.zinc]
  end

  def nodes
    stacks.map(&:nodes).flatten
  end

  def graph
    graph = RGL::DirectedAdjacencyGraph[*nodes]
    graph.write_to_graphic_file('jpg')
    `open graph.jpg`
    graph
  end
end
