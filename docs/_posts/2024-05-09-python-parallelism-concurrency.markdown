---
layout: post
title:  "Python Parallelism and Concurrency"
date:   2024-05-09 00:00:00 -0700
categories: Programming
---

In this post we'll discuss how to implement parallelism in Python with threads. We'll also get into important considerations like thread safety.

## What are parallelism and concurrency?

In broad terms, we're referring to our software being able to do multiple things at the same time. Using technical terms we need to define both "parallelism" and "concurrency" as related but slightly different concepts aimed at the same broad goal of enabling multi-tasking.

**Parallelism** is enabling software to run literally at the same time on different processors to maximize the output. It's often easier to implement for independent tasks, but it can be designed to handle shared data and variables.

**Concurrency** is enabling multiple software tasks to complete in in an overlapping time period in a coordinated way. It can be done by rapidly switching back and forth between them on a single processor, and involves resource management coordination.

## When to use parallelism or concurrency?

Here are some practical examples of when you may want to use these approaches:

- A web server being able to handle multiple requests simultaneously
- Database systems to be able to handle multiple transactions
- Processing many files in parallel. For example doing image processing, which could take a while to run per image
- Processing large amounts of data when it's possible to break it down into smaller chunks for independent analysis
- Training large neural networks by distributing the training data

## Overview of threading in Python

This article will focus on threading as a concurrency solution. Know that there are other modules: concurrent.futures, multiprocessing, and asyncio to name a few.

**threading defined:** Run multiple tasks concurrently within a single process. Useful for I/O-bound tasks but has limitations in Python due to the Global Interpreter Lock (GIL).

Let's break that down more. 

"Within a single process" means that all the tasks share the same memory and context. This can be helpful if you want to read and write the same data, but dangerous because there can be unexpected interference between tasks.

"I/O bound tasks" are those waiting for input or output operations to complete, rather than using the CPU. Examples include: file reading and writing, network requests, and database queries.

"Global Interpreter Lock" refers to the way the python interpreter manages access to objects. It ensures only a single thread is executing Python at a time to simplify memory management.

## Basic threading example in Python

Before we add threading, let's write a simple Python script that fetches data from a URL.
We'll add a 2 second sleep to simulate a slower request response.

```python
import time
import urllib.request

start_time = time.time()

def get_url(url):
    with urllib.request.urlopen(url) as response:
        html = response.read()
        time.sleep(2)
        print(html[0:100])

get_url('https://reddit.com/r/news.json')
get_url('https://reddit.com/r/funny.json')

end_time = time.time()
print(f'Total time: {end_time - start_time:.1f} seconds')
# Total time: 5.6 seconds
```

Now we'll add in threading:

```python
from threading import Thread
t1 = Thread(target=get_url, args=['https://reddit.com/r/news.json'])
t1.start()

t2 = Thread(target=get_url, args=['https://reddit.com/r/funny.json'])
t2.start()

end_time = time.time()
print(f'Total time: {end_time - start_time:.1f} seconds')
# Total time: 0.0 seconds
# b'{"kind": "Listing", "data": {"after": "t3_1ezfsc5", "dist": 25, "modhash": "", "geo_filter": null, "'
# b'{"kind": "Listing", "data": {"after": "t3_1f03hth", "dist": 27, "modhash": "", "geo_filter": null, "'
```

What happened? It ran in 0 seconds and then a few seconds later our output printed? That's because the Python main thread doesn't wait for those threads, it continues executing. We can make the main thread wait with the `join` function.

```python
from threading import Thread
t1 = Thread(target=get_url, args=['https://reddit.com/r/news.json'])
t1.start()

t2 = Thread(target=get_url, args=['https://reddit.com/r/funny.json'])
t2.start()

t1.join()
t2.join()

end_time = time.time()
print(f'Total time: {end_time - start_time:.1f} seconds')
# b'{"kind": "Listing", "data": {"after": "t3_1ezfsc5", "dist": 25, "modhash": "", "geo_filter": null, "'
# b'{"kind": "Listing", "data": {"after": "t3_1f03hth", "dist": 27, "modhash": "", "geo_filter": null, "'
# Total time: 2.9 seconds
```

Great! We brought the execution time down from 5.6 seconds to 2.9 seconds. And adding a third and fourth request also still run in about 2.9 seconds. Threading for the win!

## Thread safety

The term "thread safety" is fairly loaded and may have different meanings and nuances depending on the language and use case involved. I'll focus on one aspect of this concept. Code is thread-safe when it can be run by multiple threads without unexpected or undesirable behavior.

A few examples of undesirable behavior:

- **race conditions**: you get a different result due to unpredictable timing differences in which thread runs first
- **deadlocks**: two or more threads are waiting for each other to release resources like a database connection, causing all of them to remain blocked
- **data corruption**: multiple threads try to modify shared data at the same time without proper synchronization

## Resources

- [Stackoverflow: Concurrency vs parallelism](https://stackoverflow.com/questions/1050222/what-is-the-difference-between-concurrency-and-parallelism)
- [Python documentation: threading](https://docs.python.org/3/library/threading.html)
- [Python documentation: concurrent.futures](https://docs.python.org/3/library/concurrent.futures.html)
- [Python documentation: multiprocessing](https://docs.python.org/3/library/multiprocessing.html)
- [Python documentation: asyncio](https://docs.python.org/3/library/asyncio.html)
- [Wikipedia: I/O bound tasks](https://en.wikipedia.org/wiki/I/O_bound)
