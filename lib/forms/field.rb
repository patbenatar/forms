require "active_support/inflector"
require "active_support/core_ext/class"

module Forms
  class Field
    attr_reader :namespace, :editor

    class_attribute :default_editor

    def initialize(options={})
      @namespace = options[:namespace]

      parser = Util::ComponentOptionsParser.new("Editor", options[:editor])
      editor_klass = parser.klass || self.class.default_editor
      @editor = editor_klass.new(parser.extracted_options.merge(namespace: namespace))
    end

    def value
      editor.value
    end

    def value=(value)
      editor.value = value
    end

    def parse(params)
      editor.parse(params)
    end

    def render
      Util::Renderer.html_safe "<div><label for=\"#{editor.primary_rendered_id}\">#{human_name}</label>" + editor.render + "</div>"
    end

    private

    def human_name
      name.to_s.humanize
    end

    def name
      namespace.last
    end
  end
end