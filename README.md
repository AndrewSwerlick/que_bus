# QueBus

An event bus built on top of the que queueing library.

## Installation

Add this line to your application's Gemfile:

    gem 'que_bus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install que_bus

## Usage

First generate the QueBus initializer by running que_bus:install

This will create a new file at config/intializers/que_bus.rb.

Second run rake quebus:migrate. This will add the que_jobs table and que_bus_subcribers table to your database

### Subscribing to the bus

To subscribe to events on the bus, edit the config/initializers/que_bus.rb file, specifically the QueBus.jobs block.

Start by creating a new bus like so

    bus = QueBus::Bus.new

You can then subscribe to events by calling this buses subscribe method

    bus.subscribe :my_subscription_name do
      #do stuff...
    end

Whenever an event is published to the bus, the code inside of the block will be executed

If you only want to subscribe to events for certain topics, you can pass the topics parameter

    bus.subscribe :my_subscription_name, :topics => [:foo, :bar]  do
      #do stuff....
    end

Topics can either be an array of strings or symbols, or a single string or symbol.

If you need the value of the message published to the bus, you can add an argument to your block

    bus.subscribe :my_subscription_name do |msg|
      #do stuff...
    end

The message will be passed in as the first argument

You can also create anonymous subscriptions by calling subscribe without a subscription name

    bus.subscribe do
      #do stuff...
    end

Note a new anonymous subscription will be created every single time the code is run.
This means if you have multiple copies of the rake task, or you stop and restart the rake task,
QueBus will potentially have two different subscribers running the same code. This is usually not
what you want, so we recommend you always provide a subscription name. QueBus uses the name to make sure
no subscriber is added twice.

If you choose to create an anonymous subscription QueBus automatically generates a GUID to
identify your subscription. This GUID is returned by the subscribe method, and you can use it
to identify the subscription later.

### Publishing to the bus

Anywhere in your code that you want to publish to the event bus, start by creating a new bus

    bus = QueBus::Bus.new

To publish to all subscribers on the bus, regardless of what topics they are listening for,
call publish without the topic argument.

    bus.publish "My event message"

The message can be any serializable object, so hashes of primitives are best.

To publish to only subscribers for a certain topic, call publish with the topic argument

    bus.publish "My event message", :topic => :foo

Not you can only publish to a single topic at a time

### Listeners
Sometimes you may want to wrap all the logic for responding a an event into a single class.
For that purpose, the QueBus library includes the `QueBus::Listener` module. To make a class
listen for an event, simply include the `QueBus::Listener` module and then call the following two
configuration methods

1. `topics` - `topics` takes a list of topic symbols defining which topics this listener will listen to
2. `exec_method` - `exec_method` takes a symbol denoting which method should be called when a new event is
published on any topic this class is listening to. If no method is supplied, this defaults to :run

### Using in rails
The recommended way to use QueBus with rails is through the provided rake task.
Once you have setup your subscribers in the initializer you can have a listener running
in a separate process by running the command

    rake quebus:listen

This will start a continually
running rake task that contains all your subscribers and can execute your job code when
new events are published to the bus.

If you want your event bus subscribers running in the same process as your webserver
you can change the first line of the initializer from

    QueBus.mode = :off

to

    QueBus.mode = :async


## How it works

QueBus is built on top of the [que](https://github.com/chanks/que) job queue library.
Basically for each subscriber, QueBus creates a separate que queue, as well as dynamically generating
a class that contains the block passed to the subscribe method. When the developer calls bus.publish
QueBus loops through all the subscribers and creates new jobs for each one that has subscribed to
the relevant topic. The underlying Que library executes those jobs.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/que_bus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
