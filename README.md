# StatsD for ActionsScript 3

An ActionScript 3 client for [StatsD](https://github.com/etsy/statsd), Etsy's daemon for easy stats aggregation.

This library only works from the (AIR)[http://www.adobe.com/air] runtime.

## Usage

    import org.helvector.StatsD;
    
    client = Statsd::Client.new(host, port);
    client.send('a.stat');

# Notes

[Etsy Clients](https://github.com/etsy/statsd/wiki)
[js](https://github.com/sivy/node-statsd/blob/master/lib/statsd.js)
[rb](https://github.com/reinh/statsd/)
[go](https://github.com/cactus/go-statsd-client/blob/master/statsd/main.go)
[java](https://github.com/youdevise/java-statsd-client/blob/master/src/main/java/com/timgroup/statsd/StatsDClient.java)

## Copyright

Copyright (c) 2013 Simon Gregory. See LICENSE.txt for
further details.
