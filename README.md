# Flash StatsD

An ActionScript 3 client for [StatsD](https://github.com/etsy/statsd), Etsy's daemon for easy stats aggregation.

[UDP][udp] support is only available to the [AIR](http://www.adobe.com/air) runtime. It will *not work* where the runtime sandbox is restricted, ie browser plugin.

## Setup

Download the [swc](releases/statsd-0.1.0.swc?raw=true) and add it to your project.

## Usage

Increment the counter 'specialStuff' on a statsd server listening at 127.0.0.1:8125

    client = new StatsD();
    client.increment('specialStuff');
    
Send a gauge 'royston.vasey.localPeople' of 13 to a statsd server listening at 1.2.3.4:5678

    client = new StatsD('1.2.3.4', 5678, 'royston.vasey');
    client.gauge('localPeople', 13);
    
    
Available metrics calls:

    counter(name:String, amount:int);
    
    increment(name:String);
    
    decrement(name:String);
    
    time(name:String, time:uint/*in milliseconds*/);
    
    gauge(name:String, amount:uint);
    
    histogram(name:String, amount:uint);
    
    meter(name:String, amount:uint);
        
## More Reading

The [Statsd Spec](https://github.com/b/statsd_spec).  
Other [Statsd Clients](https://github.com/etsy/statsd/wiki).  
Statsd [Python Docs](http://statsd.readthedocs.org/en/v0.5.0/) are informative.  
UDP packets may well get discarded if they exceed the [MTU](http://en.wikipedia.org/wiki/Maximum_transmission_unit) of the network.  

## Copyright

Copyright MMXIV Simon Gregory. Released under the [MIT license](http://opensource.org/licenses/MIT), see accompanying [LICENSE](LICENSE) file for further details.

[udp]: http://en.wikipedia.org/wiki/User_Datagram_Protocol "User Datagram Protocol"
