module Forms
  class CheckboxEditor < Editor
    def parse(params)
      self.value = params
    end

    def render
      Util::Renderer.html_safe <<-STRING
        <input type="hidden" value="0" name="#{root_rendered_namespace}">
        <input type="checkbox" value="1" name="#{root_rendered_namespace}" id="#{snake_cased_namespace}" #{"checked=\"checked\"" if checked?}>
      STRING
    end

    private

    def checked?
      value == "1"
    end
  end
end