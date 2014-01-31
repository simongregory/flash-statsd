//AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright MMXIV The original author or authors.
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

public class StatsDNamespaceTest
{
    private var instance:StatsD;

    private const ip:String = '127.0.0.1';
    private const port:int = 8124;

    private var server:DatagramSocket;

    [Before]
    public function before():void
    {
        server = new DatagramSocket();
        server.bind(port,ip);
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
    public function it_counts_using_a_namespace():void
    {
        instance = new StatsD(ip,port,'royston.vasey');

        expectReceiptOf('royston.vasey.taxi:1|c\n');

        instance.counter('taxi',1);
    }

    [Test(async)]
    public function it_recognises_namespaces_ending_with_a_period():void
    {
        instance = new StatsD(ip,port,'royston.vasey.');

        expectReceiptOf('royston.vasey.babs-cabs:1|c\n');

        instance.counter('babs-cabs',1);
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
