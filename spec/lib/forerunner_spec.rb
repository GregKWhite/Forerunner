require 'rspec/rails'

describe "Forerunner" do
  describe "#precede_with", type: :controller do
    context "when specifying a method to call" do
      controller do
        include Forerunner

        precede_with :target_action
        def main_action
          render plain: "OK"
        end

        def target_action
        end
      end

      it "adds a before_action to the next defined controller action" do
        routes.draw { get "main_action" => "anonymous#main_action" }

        expect(controller).to receive(:target_action).ordered
        expect(controller).to receive(:main_action).and_call_original.ordered

        get :main_action
      end
    end

    context "when passing a block" do
      controller do
        include Forerunner

        precede_with { |c| c.target_action }
        def main_action
          render plain: "OK"
        end

        def target_action
        end
      end

      it "adds a before_action that calls the passed block" do
        routes.draw { get "main_action" => "anonymous#main_action" }

        expect(controller).to receive(:target_action).ordered
        expect(controller).to receive(:main_action).and_call_original.ordered

        get :main_action
      end
    end

    context "when there are multiple methods in the controller" do
      controller do
        include Forerunner

        precede_with :target_action
        def main_action
          render plain: "OK"
        end

        def other_action
          render plain: "OK"
        end

        def target_action
        end
      end

      it "only adds the before_action to the controller action following the precede_with call" do
        routes.draw { get "other_action" => "anonymous#other_action" }

        expect(controller).not_to receive(:target_action)

        get :other_action
      end
    end
  end

  describe "#follow_with", type: :controller do
    context "when specifying a method to call" do
      controller do
        include Forerunner

        follow_with :target_action
        def main_action
          render plain: "OK"
        end

        def target_action
        end
      end

      it "adds a before_action to the next defined controller action" do
        routes.draw { get "main_action" => "anonymous#main_action" }

        expect(controller).to receive(:main_action).and_call_original.ordered
        expect(controller).to receive(:target_action).ordered

        get :main_action
      end
    end

    context "when passing a block" do
      controller do
        include Forerunner

        follow_with { |c| c.target_action }
        def main_action
          render plain: "OK"
        end

        def target_action
        end
      end

      it "adds a before_action that calls the passed block" do
        routes.draw { get "main_action" => "anonymous#main_action" }

        expect(controller).to receive(:main_action).and_call_original.ordered
        expect(controller).to receive(:target_action).ordered

        get :main_action
      end
    end

    context "when there are multiple methods in the controller" do
      controller do
        include Forerunner

        follow_with :target_action
        def main_action
          render plain: "OK"
        end

        def other_action
          render plain: "OK"
        end

        def target_action
        end
      end

      it "only adds the before_action to the controller action following the follow_with call" do
        routes.draw { get "other_action" => "anonymous#other_action" }

        expect(controller).not_to receive(:target_action)

        get :other_action
      end
    end
  end

  describe "#surround_with", type: :controller do
    context "when specifying a method to call" do
      controller do
        include Forerunner

        surround_with :target_action
        def main_action
          render plain: "OK"
        end

        def target_action
          first_action
          yield
          second_action
        end

        def first_action;end
        def second_action; end
      end

      it "adds a before_action to the next defined controller action" do
        routes.draw { get "main_action" => "anonymous#main_action" }

        expect(controller).to receive(:target_action).ordered.and_call_original
        expect(controller).to receive(:first_action).ordered
        expect(controller).to receive(:main_action).and_call_original
        expect(controller).to receive(:second_action).ordered

        get :main_action
      end
    end

    context "when passing a block" do
      controller do
        include Forerunner

        surround_with { |c, block| c.target_action(&block) }
        def main_action
          render plain: "OK"
        end

        def target_action
          first_action
          yield
          second_action
        end

        def first_action; end
        def second_action; end
      end

      it "adds a before_action that calls the passed block" do
        routes.draw { get "main_action" => "anonymous#main_action" }

        expect(controller).to receive(:target_action).ordered.and_call_original
        expect(controller).to receive(:first_action).ordered
        expect(controller).to receive(:main_action).and_call_original.ordered
        expect(controller).to receive(:second_action).ordered

        get :main_action
      end
    end

    context "when there are multiple methods in the controller" do
      controller do
        include Forerunner

        surround_with :target_action
        def main_action
          render plain: "OK"
        end

        def other_action
          render plain: "OK"
        end

        def target_action
          first_action
          yield
          second_action
        end

        def first_action; end
        def second_action; end
      end

      it "only adds the before_action to the controller action following the surround_with call" do
        routes.draw { get "other_action" => "anonymous#other_action" }

        expect(controller).not_to receive(:target_action)
        expect(controller).not_to receive(:first_action)
        expect(controller).not_to receive(:second_action)

        get :other_action
      end
    end
  end
end
