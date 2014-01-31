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
    private const socket:DatagramSocket = new DatagramSocket();
    
    private var server:String;
    private var port:int;
    private var namespaces:String;
    private var fireAndForget:Boolean;

    /**
     * Constructor.
     *
     * @param server A string defining the IP address of the server to send stats to.
     * @param port Any integer value between 1 and 65535. Permission to connect to a port number below
     *        1024 is subject to the system security policy. On Mac and Linux systems, for
     *        example, the application must be running with root privileges to connect to ports
     *        below 1024.
     * @param namespaces A string defining the namespace the stats belong to.
     * @param fireAndForget A boolean value to ignore all runtime errors when sending stats.
     *
     * @throws Error when UDP is unavailable.
     * @throws Error if the specified port is outside the acceptable range of 1 to 65535.
     */
    public function StatsD(server:String="127.0.0.1", port:uint=8125, namespaces:String='', fireAndForget:Boolean=true)
    {
        if (!DatagramSocket.isSupported)
            throw new Error('UPD is not unsupported');

        if (port < 1 || port > 65535)
            throw new Error('The specified port ' + port + ' is not within acceptable range of 1 to 65535');

        if (namespaces != '' && namespaces.charAt(namespaces.length-1) != '.')
            namespaces += '.'

        this.server = server;
        this.port = port;
        this.namespaces = namespaces;
        this.fireAndForget = fireAndForget;
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
        send(name+ ":" + time + '|ms');
    }

    public function gauge(name:String, amount:uint):void
    {
        send(name + ':' + amount + '|g')
    }

    public function histogram(name:String, amount:uint):void
    {
        send(name + ':' + amount + '|h')
    }

    public function meter(name:String, amount:uint):void
    {
        send(name + ':' + amount + '|m')
    }

    private function send(message:String):void
    {
        const bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(namespaces + message + '\n');

        try
        {
            socket.send(bytes, 0, bytes.length, server, port);
        }
        catch (error:Error)
        {
            //RangeError — This error occurs when port is less than 1 or greater than 65535.
            //ArgumentError — If the socket is not connected and address is not a well-formed IP address.
            //IOError — This error occurs: If bind() has not been called, and when default binding to the
            //          destination address family is not possible. On some operating systems, an IOErro
            //          is thrown if the connect() method is called when an ICMP "destination unreachable"
            //          message has already been received from the target host. (Thus, the error is thrown
            //          on the second failed attempt to send data, not the first.) Other operating systems,
            //          such as Windows, disregard these ICMP messages, so no error is thrown.
            //Error — when the bytes parameter is null.
            //RangeError — If offset is greater than the length of the ByteArray specified in
            //             bytes or if the amount of data specified to be written by offset
            //             plus length exceeds the data available.
            //IllegalOperationError — If the address or port parameters are specified when the socket has already been connected.

            if (!fireAndForget) throw error;
        }
    }
}
}
