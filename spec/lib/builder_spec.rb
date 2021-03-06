# frozen_string_literal: true

describe Forerunner::Builder do
  let(:controller) { Class.new(ApplicationController) }
  subject { described_class.new(controller) }

  describe ".new" do
    it "returns a new Forerunner::Builder with empty action data arrays" do
      expect(subject.actions).to eq []
    end
  end

  describe ".enqueue_action" do
    let(:action_type) { :before }
    let(:action_params) { [:foo, :bar, if: :some_expression] }
    let(:block) { nil }

    it "adds the action data to the appropriate action array" do
      subject.enqueue_action(action_type, action_params, block)
      expect(subject.actions.count).to eq 1

      action_data = subject.actions.first
      expect(action_data.action_names).to eq %i(foo bar)
      expect(action_data.options).to eq if: :some_expression
      expect(action_data.action_type).to eq :before
    end
  end

  describe ".process_actions" do
    let(:action_type) { :before }
    let(:action_params) { [:foo, :bar, if: :some_expression] }
    let(:block) { nil }

    before { subject.enqueue_action(action_type, action_params, block) }

    it "adds a callback for each of the enqueued actions" do
      subject.process_actions(:target)

      expect(subject.controller.list_before_actions).to include :foo, :bar
    end

    it "empties the action queues after adding callbacks" do
      subject.process_actions(:target)

      expect(subject.actions).to eq []
    end
  end
end
