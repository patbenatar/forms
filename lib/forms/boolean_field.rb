module Forms
  class BooleanField < Field
    self.default_editor = CheckboxEditor

    def value=(value)
      if value == true
        editor.value = "1"
      else
        editor.value = "0"
      end
    end

    def value
      if editor.value == "1"
        true
      else
        false
      end
    end
  end
end