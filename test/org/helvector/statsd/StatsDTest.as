//AS3///////////////////////////////////////////////////////////////////////////
//
// Copyright MMXIII The original author or authors.
//
////////////////////////////////////////////////////////////////////////////////

package org.helvector.statsd
{
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class StatsDTest
{
    private var instance:StatsD

    [Test]
    public function it_counts():void
    {
        instance = new StatsD();

        assertThat(instance.count('tree',1), equalTo(true));
    }

    [Test(expects='Error')]
    public function it_errors_if_the_platform_is_unsupported():void
    {
        instance = new StatsD();
    }
}
}
