# Flash StatsD

An ActionScript 3 client for [StatsD](https://github.com/etsy/statsd), Etsy's daemon for easy stats aggregation.

UDP support is only available to the [AIR](http://www.adobe.com/air) runtime. It will fail on other platforms.

## Usage

    import org.helvector.StatsD;
    
    client = new StatsD(host, port);
    client.counter('stat', 1);

## Notes

[Statsd Spec](https://github.com/b/statsd_spec)
[Etsy Clients](https://github.com/etsy/statsd/wiki)

## Copyright

Copyright MMXIII Simon Gregory. See LICENSE for further details.
