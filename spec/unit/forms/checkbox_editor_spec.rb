require "spec_helper"

describe Forms::CheckboxEditor do
  subject { described_class.new(namespace: [:nested, :name]) }

  describe "#render" do
    it "outputs an input of type checkbox" do
      expect(subject.render).to have_xpath "//input[@type='checkbox']"
    end

    it "outputs a hidden input to handle unchecked submissions" do
      expect(subject.render).to have_xpath "//input[@type='hidden']"
    end

    it "outputs the hidden input before the checkbox" do
      output = subject.render
      expect(output.index("hidden")).to be < output.index("checkbox")
    end

    it "sets the checkbox value to 1" do
      expect(subject.render).to have_xpath "//input[@type='checkbox' and @value='1']"
    end

    it "sets the hidden input value to 0" do
      expect(subject.render).to have_xpath "//input[@type='hidden' and @value='0']"
    end

    it "checks the checkbox when value is 1" do
      subject.value = "1"
      expect(subject.render).to have_xpath "//input[@type='checkbox' and @checked='checked']"
    end

    it "does not check the checkbox when value is 0" do
      subject.value = "0"
      expect(subject.render).not_to have_xpath "//input[@type='checkbox' and @checked='checked']"
    end

    it "outputs the checkbox's name according to its namespace" do
      expect(subject.render).to have_xpath "//input[@type='checkbox' and @name='nested[name]']"
    end

    it "names the hidden input identically" do
      expect(subject.render).to have_xpath "//input[@type='hidden' and @name='nested[name]']"
    end

    it "sets the ID to snake-case name" do
      expect(subject.render).to have_xpath "//input[@id='nested_name']"
    end
  end

  describe "#parse" do
    it "sets the value to that of the params" do
      subject.parse("1")
      expect(subject.value).to eq "1"
    end
  end
end