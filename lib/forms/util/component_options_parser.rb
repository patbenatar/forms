module Forms
  module Util
    # Parses the following types of input and instantiates the object:
    # :my_class --> MyClass.new
    # { my_class: {} } --> MyClass.new({})
    # YourClass --> YourClass.new
    # { YourClass => {} } --> YourClass.new({})
    class ComponentOptionsParser
      attr_reader :klass, :extracted_options

      def initialize(component_type, options)
        @component_type = component_type
        @extracted_options = {}

        @klass = if options.is_a?(Hash)
          @extracted_options = options.first.last
          constantize(options.first.first)
        elsif options
          constantize(options)
        end
      end

      private

      attr_reader :component_type

      def constantize(name)
        if name.is_a?(Symbol)
          constantize_component_name(name)
        elsif name.class == Class
          name
        else
          raise InvalidComponent, "Could not instantiate #{component_type} from options"
        end
      end

      def constantize_component_name(name)
        "Forms::#{name.to_s.camelize}#{component_type}".constantize
      rescue NameError
        raise InvalidComponent, "Could not find #{component_type} class for #{name}"
      end
    end
  end
end