module Forms
  module Util
    module Renderer
      def self.html_safe(string)
        if string.respond_to?(:html_safe)
          string.html_safe
        else
          string
        end
      end
    end
  end
end