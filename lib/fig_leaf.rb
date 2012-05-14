# Tools for making inherited interfaces private to a class.
module FigLeaf
  module Macros
    private
    # Given a list of classes, modules, strings, and symbols, compile
    # a combined list of methods. Classes and modules will be queried
    # for their instance methods; strings and symbols will be treated
    # as method names. 
    #
    # Once the list is compiled, make all of the methods private.
    #
    # Takes an optional options hash, which can include the following options:
    #
    # - :ancestors is a boolean determining whether to consider
    #   ancestors classes and modules.
    #
    # - :except is a list of classes, modules, and method names which
    #   will be excluded from treatment.
    def hide(*stuff)
      hide_methods(self, [Object], *stuff)
    end

    # Like #hide, only hides methods at the class/module level.
    def hide_singletons(*stuff)
      hide_methods(singleton_class, [Class], *stuff)
    end

    # The shared bits of #hide and #hide_singletons
    def hide_methods(mod, except_defaults, *stuff)
      options = stuff.last.is_a?(Hash) ? stuff.pop : {}
      include_ancestors  = options.fetch(:ancestors){false}
      except             = Array(options.fetch(:except){except_defaults})
      protect            = Array(options[:protect])
      except_methods     = collect_methods(true, *except)
      protect_methods    = collect_methods(true, *protect)
      methods_to_hide    = collect_methods(include_ancestors, *stuff)
      (methods_to_hide - except_methods).each do |method_name|
        mod.module_eval do 
          next unless method_defined?(method_name)
          if protect_methods.include?(method_name)
            protected method_name
          else
            private method_name
          end
        end
      end
    end

    # Given a list of classes, modules, strings, and symbols, compile
    # a combined list of methods. Classes and modules will be queried
    # for their instance methods; strings and symbols will be treated
    # as methods names. +include_ancestors+ determines whether to
    # include methods defined by class/module ancestors.
    def collect_methods(include_ancestors, *methods_or_modules)
      methods_or_modules.inject([]) {|methods, method_or_module|
        case method_or_module
        when Symbol, String
          methods << method_or_module.to_sym
        when Module # also includes classes
          methods.concat(method_or_module.instance_methods(include_ancestors))
        when Array
          methods.concat(method_or_module)
        else
          raise ArgumentError, "Bad argument: #{method_or_module.inspect}"
        end
      }
    end
  end

  def self.clothe(other)
    other.extend(Macros)
  end

  def self.included(other)
    clothe(other)
    other.singleton_class.extend(Macros)
  end

  def self.extended(object)
    clothe(object.singleton_class)
  end
end