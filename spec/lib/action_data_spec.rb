# frozen_string_literal: true

describe Forerunner::ActionData do
  let(:action_type) { :before }
  let(:action_data) { [:foo, :bar, if: :some_condition] }
  subject { described_class.new(action_type: action_type, action_data: action_data) }

  describe ".new" do
    it "returns a new Forerunner::ActionData instance" do
      expect(subject.action_names).to eq %i(foo bar)
      expect(subject.options).to eq if: :some_condition
    end

    context "when there are no action names present" do
      let(:action_data) { [] }

      it "throws a Forerunner::ActionData::MissingActionNameError" do
        expect { subject }.to raise_error(Forerunner::ActionData::MissingActionNameError)
      end

      context "when there is a block" do
        let(:action_block) { proc { puts "yay" } }
        subject do
          described_class.new(
            action_type: action_type,
            action_data: action_data,
            block: action_block
          )
        end

        it "does not throw an error" do
          expect { subject }.not_to raise_error
        end
      end
    end

    context "when given an invalid action type" do
      let(:action_type) { :invalid }

      it "throws a Forerunner::ActionData::InvalidActionTypeError" do
        expect { subject }.to raise_error(Forerunner::ActionData::InvalidActionTypeError)
      end
    end
  end

  describe ".limit_to_action" do
    it "sets to :only flag of the options to the target method" do
      subject.limit_to_action(:foo)

      expect(subject.options[:only]).to eq [:foo]
    end
  end
end
