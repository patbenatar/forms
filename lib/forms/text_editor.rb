module Forms
  class TextEditor < Editor
    def parse(params)
      self.value = params
    end

    def render
      Util::Renderer.html_safe "<input type=\"text\" value=\"#{value}\" name=\"#{root_rendered_namespace}\" id=\"#{snake_cased_namespace}\">"
    end
  end
end