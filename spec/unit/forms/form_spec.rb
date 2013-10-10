require "spec_helper"

Forms::SomeCoolCustomField = Class.new(Forms::Field)

describe Forms::Form do
  subject { described_class.new }

  describe "class DSL" do
    subject { described_class }

    describe ".field" do
      after do
        subject.field_intents = nil # reset
      end

      it "stores the args as an intent to build a Field at instantiation" do
        args = [:name, string: :multipart_name]
        subject.field *args
        expect(subject.field_intents.first).to eq args
      end

      it "stores many intents" do
        subject.field :name
        subject.field :email
        expect(subject.field_intents.length).to eq 2
      end

      it "defaults to string fields" do
        subject.field :name
        expect(subject.field_intents.first).to eq [:name, :string]
      end
    end
  end

  describe "#initialize" do
    after do
      described_class.field_intents = nil # reset
    end

    context "with valid field types" do
      before { described_class.field :name, :some_cool_custom }

      it "instantiates the appropriate field class" do
        Forms::SomeCoolCustomField.should_receive(:new)

        described_class.new
      end
    end

    context "with a nonexistent field type" do
      before { described_class.field :name, :ekfjhkhfejeh }

      it "raises" do
        expect { described_class.new }.to raise_error Forms::InvalidComponent
      end
    end

    context "with a field class" do
      before(:all) do
        MyHomemadeField = Class.new(Forms::Field)
      end

      before { described_class.field :name, MyHomemadeField }

      it "uses that field class" do
        MyHomemadeField.should_receive(:new)

        described_class.new
      end
    end

    context "with options for the field" do
      let(:options) { { hey: "there" } }
      before { described_class.field :name, some_cool_custom: options }

      it "instantiates the field with options" do
        Forms::SomeCoolCustomField.should_receive(:new).with(options.merge(namespace: [:forms_form, :name]))

        described_class.new
      end
    end
  end

  describe "#namespace" do
    it "converts the class name to a renderable namespace name" do
      Scoped = Module.new
      Scoped::MyCustomForm = Class.new(described_class)
      subject = Scoped::MyCustomForm.new

      expect(subject.namespace).to eq [:scoped_my_custom_form]
    end

    context "when supplied via options" do
      it "returns the one supplied" do
        subject = described_class.new(namespace: [:nested, :form])
        expect(subject.namespace).to eq [:nested, :form]
      end
    end
  end

  context "with some registered field_intents" do
    before(:all) do
      described_class.field :name
      described_class.field :email
    end


    describe "#render" do
      before do
        subject.fields[:name].should_receive(:render).and_return("Name Field Render")
        subject.fields[:email].should_receive(:render).and_return("Email Field Render")
      end

      it "renders all of its fields" do
        output = subject.render
        expect(output).to include "Name Field Render"
        expect(output).to include "Email Field Render"
      end
    end

    describe "#parse" do
      let(:params) do
        {
          name: {
            first_name: "Nick",
            last_name: "Giancola",
          },
          email: "nick@gophilosophie.com",
        }
      end

      it "passes relevant params to its fields" do
        subject.fields[:name].should_receive(:parse).with({
          first_name: "Nick",
          last_name: "Giancola",
        })

        subject.fields[:email].should_receive(:parse).with("nick@gophilosophie.com")

        subject.parse(params)
      end
    end

    describe "#value" do
      it "collects data from its fields" do
        subject.fields[:name].should_receive(:value).and_return("Frank")
        subject.fields[:email].should_receive(:value).and_return("frank@gophilosophie.com")

        expect(subject.value).to eq({ name: "Frank", email: "frank@gophilosophie.com" })
      end
    end

    describe "#value=" do
      let(:value) do
        {
          name: "Nick Giancola",
          email: "nick@gophilosophie.com",
        }
      end

      it "passes relevant params to its fields" do
        subject.fields[:name].should_receive(:value=).with("Nick Giancola")
        subject.fields[:email].should_receive(:value=).with("nick@gophilosophie.com")

        subject.value = value
      end
    end
  end
end