require "forms/version"

module Forms
  class InvalidComponent < Exception; end

  autoload :Form, "forms/form"

  autoload :Field, "forms/field"
  autoload :StringField, "forms/string_field"

  autoload :Editor, "forms/editor"
  autoload :TextEditor, "forms/text_editor"

  autoload :Util, "forms/util"
end
