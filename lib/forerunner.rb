# frozen_string_literal: true
require "active_support"
require "forerunner/analyzer"
require "forerunner/action_data"
require "forerunner/action_data/missing_action_name_error"
require "forerunner/action_data/invalid_action_type_error"
require "forerunner/builder"

module Forerunner
  extend ActiveSupport::Concern

  class_methods do
    def precede_with(*filter_params, &block)
      forerunner_builder.enqueue_action(:before, filter_params, block)
    end

    def follow_with(*filter_params, &block)
      forerunner_builder.enqueue_action(:after, filter_params, block)
    end

    def surround_with(*filter_params, &block)
      forerunner_builder.enqueue_action(:around, filter_params, block)
    end

    def method_added(controller_action)
      forerunner_builder.process_actions(controller_action)
    end

    def forerunner_builder
      @forerunner_builder ||= Forerunner::Builder.new(self)
    end
  end
end
