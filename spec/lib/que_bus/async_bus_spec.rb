require_relative '../../spec_helper'

describe Bus do
  describe "when we create a new bus" do
    let(:bus) {Bus.new }
    before do
      Que.mode = :off
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

  end
end
