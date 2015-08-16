require 'spec_helper'

describe QueBus do
  it "must be defined" do
    QueBus::VERSION.wont_be_nil
  end
end
