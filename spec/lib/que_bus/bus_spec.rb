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

    describe "when we have a subscriber in the database that is not currently connected" do
      before do
        Subscriber.create(id: "test", job_class: "Jobs::Jobtest")
      end

      it "still allows us to publish a message" do
        bus.publish("offline_test")
      end

      describe "and we publish a message and then connect the subscriber" do
        before do
          bus.publish("reconnect_test")
          bus.subscribe("test") do
            @event_recieved = true
          end
        end

        it "recieves the message when the subscriber comes back on line" do
          @event_recieved.must_equal true
        end
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
