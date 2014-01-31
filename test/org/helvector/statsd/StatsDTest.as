//AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright MMXIII The original author or authors.
//
////////////////////////////////////////////////////////////////////////////////

package org.helvector.statsd
{
import flash.events.DatagramSocketDataEvent;
import flash.net.DatagramSocket;
import flash.utils.ByteArray;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class StatsDTest
{
    private var instance:StatsD;
    private var server:DatagramSocket;

    [Before]
    public function before():void
    {
        instance = new StatsD();

        server = new DatagramSocket();
        server.bind(8125, '127.0.0.1');
        server.receive();
    }

    [After]
    public function after():void
    {
        server.close();
        server = null;
        instance = null;
    }

    [Test(expects='Error')]
    public function it_fails_to_instantiate_with_invalid_low_port_number():void
    {
        instance = new StatsD('127.0.0.1', 0);
    }

    [Test(expects='Error')]
    public function it_fails_to_instantiate_with_invalid_high_port_number():void
    {
        instance = new StatsD('127.0.0.1', 65536);
    }

    [Test(async)]
    public function it_coerces_invalid_port_numbers_to_integers_at_instantiation():void
    {
        instance = new StatsD('127.0.0.1', 8125.33333333);

        expectReceiptOf('tubbs:1|c\n');

        instance.counter('tubbs', 1);
    }

    [Test(async)]
    public function it_counts():void
    {
        expectReceiptOf('pauline:1|c\n');

        instance.counter('pauline', 1);
    }

    [Test(async)]
    public function it_increments():void
    {
        expectReceiptOf('edward:1|c\n');

        instance.increment('edward');
    }

    [Test(async)]
    public function it_decrements():void
    {
        expectReceiptOf('mickey:-1|c\n');

        instance.decrement('mickey');
    }

    [Test(async)]
    public function it_times():void
    {
        expectReceiptOf('tree:10101|ms\n');

        instance.time('tree', 10101);
    }

    [Test(async)]
    public function it_gauges():void
    {
        expectReceiptOf('barbra:5|g\n');

        instance.gauge('barbra',5);
    }

    [Test(async)]
    public function it_histograms():void
    {
        expectReceiptOf('herr-lipp:5|h\n');

        instance.histogram('herr-lipp',5);
    }

    [Test(async)]
    public function it_uses_a_namespace_when_set():void
    {
        instance = new StatsD('127.0.0.1', 8125, 'legz');

        expectReceiptOf('legz.akimbo:1|c\n');

        instance.counter('akimbo',1);
    }

    private function dataReceived(event:DatagramSocketDataEvent, ...args):void
    {
        const bytes:ByteArray = ByteArray(event.data);
        const expected:String = args[0];
        const received:String = bytes.readUTFBytes(bytes.bytesAvailable);

        assertThat(received, equalTo(expected));
    }

    private function expectReceiptOf(s:String):void
    {
        Async.handleEvent(this, server, DatagramSocketDataEvent.DATA, dataReceived, 500, s);
    }
}
}
