//AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright MMXIV The original author or authors.
//
////////////////////////////////////////////////////////////////////////////////

package org.helvector.statsd
{
public class StatsDFireAndForgetTest
{
    [Test(expects='Error')]
    public function it_errors_when_sending_a_message_to_an_invalid_ip_address():void
    {
        const instance:StatsD = new StatsD('not-an-ip-address', 1234, 'namespace', false);

        instance.decrement('thing');
    }

    [Test]
    public function errors_are_not_thrown_in_fire_and_forget_mode():void
    {
        const instance:StatsD = new StatsD('not-an-ip-address', 1234);

        instance.decrement('thing');
    }
}
}
