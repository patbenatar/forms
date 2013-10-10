require "spec_helper"

describe Forms::Field do
  subject { described_class.new(namespace: namespace) }
  let(:namespace) { [:name] }

  before(:all) do
    Forms::DummyDefaultEditor = Class.new(Forms::Editor)
    described_class.default_editor = Forms::DummyDefaultEditor

    Forms::SomeCoolCustomEditor = Class.new(Forms::Editor)
  end

  describe "#initialize" do
    it "stores the namespace" do
      subject = described_class.new(namespace: namespace)
      expect(subject.namespace).to eq namespace
    end

    it "instantiates the default editor" do
      Forms::DummyDefaultEditor.should_receive(:new)

      described_class.new namespace: namespace
    end

    it "passes the namespace down to the editor" do
      Forms::DummyDefaultEditor.should_receive(:new).with({ namespace: namespace })

      described_class.new namespace: namespace
    end

    context "with a valid editor name" do
      it "instantiates the appropriate editor class" do
        Forms::SomeCoolCustomEditor.should_receive(:new)

        described_class.new namespace: namespace, editor: :some_cool_custom
      end
    end

    context "with a nonexistent editor name" do
      it "raises" do
        expect { described_class.new namespace: namespace, editor: :ekhfkekhekjf }.to raise_error Forms::InvalidComponent
      end
    end

    context "with an editor class" do
      it "uses that editor class" do
        SomeCoolCustomEditor = Class.new(Forms::Editor)
        SomeCoolCustomEditor.should_receive(:new)

        described_class.new namespace: namespace, editor: SomeCoolCustomEditor
      end
    end

    context "with options for the editor" do
      it "instantiates the editor with options" do
        options = { hey: "there" }
        Forms::SomeCoolCustomEditor.should_receive(:new).with({ namespace: namespace }.merge(options))

        described_class.new namespace: namespace, editor: { some_cool_custom: options }
      end
    end
  end

  describe "#render" do
    before do
      subject.editor.should_receive(:render).and_return("Editor Here!")
      subject.editor.should_receive(:primary_rendered_id).and_return("the_name")
    end

    it "renders the editor" do
      expect(subject.render).to include "Editor Here!"
    end

    it "renders a label for the editor" do
      expect(subject.render).to have_xpath "//label[@for='the_name']"
    end

    it "humanizes the name and puts it in the label" do
      expect(subject.render).to include "Name"
    end
  end

  describe "#parse" do
    it "delegates to the editor" do
      params = { first_name: "Nick", last_name: "Giancola" }
      subject.editor.should_receive(:parse).with(params)

      subject.parse(params)
    end
  end

  describe "#value" do
    it "delegates to the editor" do
      subject.editor.should_receive(:value)
      subject.value
    end
  end

  describe "#value=" do
    it "delegates to the editor" do
      value = "Nick Giancola"

      subject.editor.should_receive(:value=).with(value)
      subject.value = value
    end
  end
end