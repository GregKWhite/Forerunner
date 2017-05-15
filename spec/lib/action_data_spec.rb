# frozen_string_literal: true

describe Forerunner::ActionData do
  describe ".new" do
    let(:action_type) { :before }
    let(:action_data) { [:foo, :bar, if: :some_condition] }
    subject { described_class.new(action_type: action_type, action_data: action_data) }

    it "returns a new Forerunner::ActionData instance" do
      expect(subject.action_names).to eq %i(foo bar)
      expect(subject.options).to eq if: :some_condition
      expect(subject.action_type).to eq :before
    end

    context "when given an invalid action type" do
      let(:action_type) { :invalid }

      it "throws a Forerunner::ActionData::InvalidActionTypeError" do
        expect { subject }.to raise_error(Forerunner::ActionData::InvalidActionTypeError)
      end
    end

    context "when there are no action names present" do
      let(:action_data) { [] }

      it "throws a Forerunner::ActionData::MissingActionNameError" do
        expect { subject }.to raise_error(Forerunner::ActionData::MissingActionNameError)
      end
    end
  end
end
