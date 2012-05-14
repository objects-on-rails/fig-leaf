gem 'minitest' # demand gem version
require 'minitest/autorun'
require_relative '../lib/fig-leaf'

def wipe_classes 
  if defined? Grandparent
    Object.send(:remove_const, :Grandparent) 
    Object.send(:remove_const, :Parent) 
    Object.send(:remove_const, :Child) 
  end
  load File.join(File.dirname(__FILE__), 'classes_for_tests.rb')
end


describe 'FigLeaf' do 
  before :each do 
    wipe_classes
  end
  
  it 'hides a single class method' do
    Child.child_public_class_method.must_equal 42
    class Child
      include FigLeaf
      hide_singletons :child_public_class_method
    end
    proc { Child.child_public_class_method }.must_raise NoMethodError
  end
  
  it 'hides instance methods' do
    Child.new.child_public_instance_method.must_equal 42
    class Child
      include FigLeaf
      hide :child_public_instance_method
    end
    proc { Child.new.child_public_instance_method }.must_raise NoMethodError
  end
  
  it 'deeply hides methods from ancestor objects' do
    Child.new.grandparent_public_instance_method.must_equal 42
    Child.new.parent_public_instance_method.must_equal 42
    class Child
      include FigLeaf
      hide Parent, ancestors: true
    end
    proc { Child.new.grandparent_public_instance_method }.must_raise NoMethodError
    proc { Child.new.parent_public_instance_method }.must_raise NoMethodError
  end
  
  it 'does not hide ancestors if not asked to' do
    Child.new.grandparent_public_instance_method.must_equal 42
    class Child
      include FigLeaf
      hide Parent
    end
    Child.new.grandparent_public_instance_method.must_equal 42
  end
  
  it 'allows you to specify single instance method to keep visible' do
    Child.new.child_public_instance_method.must_equal 42
    Child.new.second_child_public_instance_method.must_equal 42
    class Child
      include FigLeaf
      hide self, except: :second_child_public_instance_method
    end
    proc { Child.new.child_public_instance_method }.must_raise NoMethodError
    Child.new.second_child_public_instance_method.must_equal 42
  end
  
  it 'allows you to specify entire class instance method exceptions to keep visible' do
    Child.new.grandparent_public_instance_method.must_equal 42
    Child.new.parent_public_instance_method.must_equal 42
    class Child
      include FigLeaf
      hide Parent, ancestors: true, except: [Grandparent]
    end
    Child.new.grandparent_public_instance_method.must_equal 42
    proc { Child.new.parent_public_instance_method }.must_raise NoMethodError
  end
  
  it 'allows you to specify more than one exception to keep visible' do
    Child.new.child_public_instance_method.must_equal 42
    Child.new.second_child_public_instance_method.must_equal 42
    Child.new.grandparent_public_instance_method.must_equal 42
    class Child
      include FigLeaf
      hide self, except: [:second_child_public_instance_method, :grandparent_public_instance_method]
    end
    proc { Child.new.child_public_instance_method }.must_raise NoMethodError
    Child.new.second_child_public_instance_method.must_equal 42
    Child.new.grandparent_public_instance_method.must_equal 42
  end
  
  # it 'does not pollute your interface by making its own methods public' do
  #     proc { Child.hide(Parent) }.must_raise NoMethodError
  #     class Child
  #       include FigLeaf
  #       hide self
  #     end
  #     proc { Child.hide(Parent) }.must_raise NoMethodError
  #   end
end
