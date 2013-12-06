//AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright MMXIII The original author or authors.
//
////////////////////////////////////////////////////////////////////////////////

package org.helvector.statsd
{
import flash.net.DatagramSocket;
import flash.utils.ByteArray;

public class StatsD
{
    private var socket:DatagramSocket = new DatagramSocket();
    private var server:String;
    private var port:int;

    public function StatsD(server:String="127.0.0.1", port:uint=8125)
    {
        if (!DatagramSocket.isSupported)
            throw new Error('UPD is not unsupported');

        this.server = server;
        this.port = port;
    }

    public function counter(name:String, amount:int):void
    {
        send(name + ':' + amount + '|c');
    }

    public function increment(name:String):void
    {
        counter(name,1);
    }

    public function decrement(name:String):void
    {
        counter(name,-1);
    }

    public function time(name:String, time:uint/*in milliseconds*/):void
    {
        send(name+ ":" + time + "|ms");
    }

    public function gauge(name:String, amount:uint):void
    {
        send(name + ':' + amount + "|g")
    }

    public function histogram(name:String, amount:uint):void
    {
        send(name + ':' + amount + "|h")
    }

    public function meter(name:String, amount:uint):void
    {
        send(name + ':' + amount + "|m")
    }

    private function send(message:String):void
    {
        const bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(message+'\n');

        try
        {
            socket.send(bytes, 0, bytes.length, server, port);
        }
        catch (error:Error)
        {
            trace(error.message);
        }
    }
}
}
