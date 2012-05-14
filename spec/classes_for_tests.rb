class Grandparent
  def grandparent_public_instance_method; 42; end
  def self.grandparent_public_class_method; 42; end
end

class Parent < Grandparent
  def parent_public_instance_method; 42; end
  def self.parent_public_class_method; 42; end
end

class Child < Parent
  def child_public_instance_method; 42; end
  def second_child_public_instance_method; 42; end
  def self.child_public_class_method; 42; end
end