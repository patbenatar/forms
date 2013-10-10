require "spec_helper"

describe Forms::StringField do
  it "uses TextEditor as its default editor" do
    expect(described_class.default_editor).to eq Forms::TextEditor
  end
end