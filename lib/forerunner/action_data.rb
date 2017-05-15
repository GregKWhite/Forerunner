module Forerunner
  class ActionData
    VALID_ACTION_TYPES = %i(before around after)

    attr_reader :options, :action_names, :block, :action_type

    def initialize(action_type:, action_data:, block: nil)
      @action_type = action_type
      @options = action_data.extract_options!
      @action_names = action_data
      @block = block

      validate_action_type!
      validate_action_names!
    end

    private

    def validate_action_type!
      return if VALID_ACTION_TYPES.include?(action_type)

      raise InvalidActionTypeError, action_type
    end

    def validate_action_names!
      return if action_names.present?

      raise MissingActionNameError
    end
  end
end
