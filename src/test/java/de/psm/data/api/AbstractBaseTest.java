package de.psm.data.api;

import java.util.concurrent.TimeUnit;

abstract class AbstractBaseTest
{
    void slowDown(boolean beNice) throws InterruptedException
    {
        if(beNice)
        {
            TimeUnit.SECONDS.sleep(1);
        }
    }
}
