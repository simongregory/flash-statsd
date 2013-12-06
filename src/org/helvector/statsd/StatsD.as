//AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright MMXIII Original author or authors.
//
////////////////////////////////////////////////////////////////////////////////

package org.helvector.statsd
{
import flash.net.DatagramSocket;

public class StatsD
{
    private var socket:DatagramSocket = new DatagramSocket();

    public function StatsD()
    {
        if (!DatagramSocket.isSupported)
            throw new Error('Platform is unsupported');
    }

    public function count(name:String, amount:int):Boolean
    {
        return true;
    }
}
}
