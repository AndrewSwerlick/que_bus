require_relative '../../spec_helper'

describe Bus do
  describe "when we create a new bus and run it in async mode" do
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

    it "allows us to subscribe to all channels on the bus" do
      bus.subscribe
    end

    it "allows us to publish to a channel" do
      bus.publish("foo", {test: "test"})
    end

    it "allows us to publish to all listeners on the bus" do
      bus.publish({test:"test"})
    end
  end
end
