require "spec_helper"

describe Forms::TextEditor do
  subject { described_class.new(namespace: [:nested, :name]) }

  describe "#render" do
    it "outputs an input of type text" do
      expect(subject.render).to have_xpath "//input[@type='text']"
    end

    it "outputs the current value into the input" do
      subject.value = "Nick"
      expect(subject.render).to have_xpath "//input[@value='Nick']"
    end

    it "outputs the name according to its namespace" do
      expect(subject.render).to have_xpath "//input[@name='nested[name]']"
    end

    it "sets the ID to snake-case name" do
      expect(subject.render).to have_xpath "//input[@id='nested_name']"
    end
  end

  describe "#parse" do
    it "sets the value to that of the params" do
      subject.parse("Nick")
      expect(subject.value).to eq "Nick"
    end
  end
end