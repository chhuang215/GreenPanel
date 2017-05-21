
import asyncio
import datetime

async def addition(x, y):
    print("Adding %d and %d, giving you answer later..." % (x, y))
    await asyncio.sleep(1)
    print("%d + %d = %d" % (x, y, x+y))



tasks = [asyncio.ensure_future(addition(x, (x+1)*2)) for x in range(5)]

loop = asyncio.get_event_loop()

loop.run_until_complete(asyncio.gather(*tasks))

