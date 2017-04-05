class TestClass < Que::Job
  def run(message, options)
    message[:event_recieved] = true
  end
end
