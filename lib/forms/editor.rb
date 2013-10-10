module Forms
  class Editor
    attr_accessor :value
    attr_reader :namespace

    def initialize(options={})
      @namespace = options[:namespace]
    end

    def parse(params)
      raise NotImplementedError.new("Implement #parse in subclass.")
    end

    def render
      raise NotImplementedError.new("Implement #render in subclass.")
    end

    def primary_rendered_id
      snake_cased_namespace
    end

    private

    def snake_cased_namespace
      namespace.join("_")
    end

    def root_rendered_namespace
      @root_rendered_namespace ||= namespace.each_with_index.map do |n,i|
        i == 0 ? n : "[#{n}]"
      end.join
    end
  end
end