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

    [Test(async)]
    public function it_counts():void
    {
        expectReceiptOf('tree:1|c\n');

        instance.counter('tree',1);
    }

    [Test(async)]
    public function it_increments():void
    {
        expectReceiptOf('tree:1|c\n');

        instance.increment('tree');
    }

    [Test(async)]
    public function it_decrements():void
    {
        expectReceiptOf('tree:-1|c\n');

        instance.decrement('tree');
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
        expectReceiptOf('basil:5|g\n');

        instance.gauge('basil',5);
    }

    [Test(async)]
    public function it_histograms():void
    {
        expectReceiptOf('brush:5|h\n');

        instance.histogram('brush',5);
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
