require_relative '../../spec_helper'

describe Bus do
  describe "when we create a new bus" do
    let(:bus) {Bus.new }

    describe "and subscribe the bus" do
      before do
        @id = bus.subscribe
      end

      it "gives us a subscription id" do
        @id.wont_be_nil
      end
    end

    describe "when we subscribe to the bus with our own id" do
      before do
        @id = bus.subscribe("test")
      end

      it "gives us the same id back" do
        @id.must_equal "test"
      end
    end

    describe "when we subscribe to the bus with a block and publish a message" do
      before do
        bus.subscribe do
          @event_recieved = true
        end
        bus.publish({test: "Test"})
      end

      it "recieved the event" do
        @event_recieved.must_equal true
      end
    end

    describe "when we subscribe to the bus with a block that takes an argument and publish a message" do
      before do
        bus.subscribe do |msg|
          @event_recieved = msg[:value]
        end
        bus.publish({value: true})
      end

      it "recieved the event" do
        @event_recieved.must_equal true
      end
    end

    describe "when we subscribe to the bus twice with a block and publish a message" do
      before do
        bus.subscribe do
          @event1_recieved = true
        end
        bus.subscribe do
          @event2_recieved = true
        end

        bus.publish({test: "test"})
      end

      it "recieves both events" do
        @event1_recieved.must_equal true
        @event2_recieved.must_equal true
      end
    end

    describe "when we subscribe in one bus and publish in a different bus" do
      before do
        bus.subscribe do
          @event_recieved = true
        end

        Bus.new.publish("test")
      end

      it "recieves the event" do
        @event_recieved.must_equal true
      end
    end

    describe "when we subscribe to a specific channel" do
      before do
        bus.subscribe(:topics=> :foo) do
          @foo_event_called = true
        end
      end

      describe "and we publish to the same channel" do
        before do
          bus.publish("hey foo", :topic => :foo)
        end

        it "recieves the foo event" do
          @foo_event_called.must_equal true
        end
      end

      describe "and we publish on a different channel" do
        before do
          bus.publish("hey foo",:topic=> :bar)
        end

        it "does not recieve the foo event" do
          @foo_event_called.must_be_nil
        end
      end

      describe "and we publish with no defined channel" do
        before do
          bus.publish("hey foo")
        end

        it "recieves the message" do
          @foo_event_called.must_equal true
        end
      end
    end



  end
end
