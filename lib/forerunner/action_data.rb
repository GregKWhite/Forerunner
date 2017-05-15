module Forerunner
  class ActionData
    attr_reader :options, :action_names, :block

    def initialize(action_data:, block: nil)
      @options = action_data.extract_options!
      @action_names = action_data
      @block = block

      validate_action_names!
    end

    def limit_to_action(action)
      options[:only] = [action]
    end

    def params
      action_names + [options]
    end

    private

    def validate_action_names!
      return if action_names.present?

      raise MissingActionNameError
    end
  end
end
