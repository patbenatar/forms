require "spec_helper"

describe Forms::Editor do
  subject { described_class.new(namespace: [:nested, :name]) }

  describe "#initialize" do
    it "stores the namespace" do
      expect(subject.namespace).to eq [:nested, :name]
    end
  end

  describe "#value" do
    it "provides read/write access to the current value" do
      subject.value = "Test"
      expect(subject.value).to eq "Test"
    end
  end

  describe "#parse" do
    it "must be implemented in subclass" do
      expect { subject.parse({}) }.to raise_error NotImplementedError
    end
  end

  describe "#render" do
    it "must be implemented in subclass" do
      expect { subject.render }.to raise_error NotImplementedError
    end
  end

  describe "#primary_rendered_id" do
    it "returns the namespace as a snake-case string for use as an HTML ID" do
      expect(subject.primary_rendered_id).to eq "nested_name"
    end
  end
end