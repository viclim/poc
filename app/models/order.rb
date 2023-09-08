class Order
  attr_accessor :order, :project

  def initialize(order, project)
    @order = order
    @project = if project.is_a? Project
                 project.name
               else
                 project
               end
  end
end
