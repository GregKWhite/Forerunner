# frozen_string_literal: true
module Forerunner
  class ActionData
    class InvalidActionTypeError < StandardError
      attr_reader :action_type

      def initialize(action_type)
        @action_type = action_type
      end

      def to_s
        "Invalid action type `#{action_type}`. Valid types include #{valid_types}."
      end

      private

      def valid_types
        Forerunner::ActionData::VALID_ACTION_TYPES.map do |valid_type|
          "`#{valid_type}`"
        end.to_sentence
      end
    end
  end
end
