require "active_support"
require "forerunner/analyzer"
require "forerunner/action_data"
require "forerunner/action_data/missing_action_name_error"
require "forerunner/action_data/invalid_action_type_error"

module Forerunner
  extend ActiveSupport::Concern

  included do
    cattr_accessor :next_filter_data
    self.next_filter_data = nil
  end

  class_methods do
    def precede_with(*filter_params, &block)
      self.next_filter_data = {
        filter_params: filter_params,
        block: block,
        filter_type: :before,
      }
    end

    def method_added(controller_action)
      return unless next_filter_data.present?

      insert_new_filter(controller_action, next_filter_data)
      self.next_filter_data = nil
    end

    def insert_new_filter(action, filter_params:, filter_type:, block:)
      limit_callback_to_current_action(action, filter_params)

      _insert_callbacks(filter_params, block) do |name, options|
        set_callback(:process_action, filter_type, name, options)
      end
    end

    def limit_callback_to_current_action(action, filter_params)
      options = filter_params.extract_options!
      options[:only] = [action]
      filter_params.append(options)
    end
  end
end
