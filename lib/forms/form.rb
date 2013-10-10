require "active_support/core_ext/class"

module Forms
  class Form
    class_attribute :field_intents

    class << self
      def field(*args)
        # Default to :string field
        (self.field_intents ||= []) << (args.length > 1 ? args : args + [:string])
      end
    end

    attr_reader :namespace, :fields

    def initialize(options={})
      @namespace = options[:namespace] || [self.class.name.underscore.gsub("/", "_").to_sym]

      @fields = {}

      if field_intents
        field_intents.each do |field_args|
          name, options = field_args

          parser = Util::ComponentOptionsParser.new("Field", options)
          @fields[name] = parser.klass.new(parser.extracted_options.merge(namespace: namespace + [name]))
        end
      end
    end

    def parse(params)
      form_params = params[namespace.last] || params

      fields.each do |name, field|
        if field_params = form_params[name]
          field.parse(field_params)
        end
      end
    end

    def value=(value)
      fields.each do |name, field|
        if relevant_data = value[name]
          field.value = relevant_data
        end
      end
    end

    def value
      fields.each_with_object({}) do |(name, field), obj|
        obj[name] = field.value
      end
    end

    def render
      Util::Renderer.html_safe("".tap do |html|
        fields.each { |name, field| html << field.render }
      end)
    end
  end
end