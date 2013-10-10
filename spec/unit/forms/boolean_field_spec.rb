require "spec_helper"

describe Forms::BooleanField do
  subject { described_class.new(namespace: [:nested, :name]) }

  it "uses CheckboxEditor as its default editor" do
    expect(described_class.default_editor).to eq Forms::CheckboxEditor
  end

  it "passes true values to the editor as 1" do
    subject.editor.should_receive(:value=).with("1")
    subject.value = true
  end

  it "passes false values to the editor as 0" do
    subject.editor.should_receive(:value=).with("0")
    subject.value = false
  end

  it "interprets editor's 0 value as false" do
    subject.editor.should_receive(:value).and_return("0")
    expect(subject.value).to be_false
  end

  it "interprets editor's 1 value as true" do
    subject.editor.should_receive(:value).and_return("1")
    expect(subject.value).to be_true
  end
end