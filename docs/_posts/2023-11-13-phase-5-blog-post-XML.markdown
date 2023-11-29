
---
layout: post
title:  "Phase 5 Blog Post: Podcast XML feeds"
date:   2023-11-28 00:00:00 -0700
categories: flatiron
---

My fifth project in the Flatiron course was building a new [Podcast app](https://github.com/rendely/phase-5-project-pawdcasts). There was a lot of external data and new technologies I needed to figure out to build it.

In this blog post I'll explain how I went about that, starting from scratch to give you ideas about how you can get unblocked on a new project.

## Figuring out what data and capabilities I needed

Once I figured out what I wanted to build, I began to think through all the data and technical capabilities my project would need, working backwards to make the dependencies clear. In my case I wanted a few things:

1. **Audio file URLs:** Users should be able to play the audio of podcast episodes directly in the web app. So I knew I ultimately needed the URL of an audio file I could stream. From some quick searching I learned that almost all podcasts have these links in their public RSS feeds. And there is a well supported HTML element [`<Audio>`](https://www.w3schools.com/html/html5_audio.asp) to play audio with just the URL.

2. **Podcast episode feed:** I needed an up-to-date RSS feed of the episodes with the title, description and audio file of each episode, so users had enough info to decide what to listen to.

3. **Podcast directory API:** I needed an API that returned a list of podcast feeds so users could search for and choose podcasts to follow. It needed a thumbnail image, title and link to the RSS feed at a minimum.

## Getting the directory API of podcasts

### Which API to use

I did some searching around, most options were paid but there were a few free ones, which is how I wanted to start prototyping my app. I knew I could always come back later and change it if I wasn't satisfied.

I chose to use the [iTunes search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html) to start because it was free without needing an API key and had good documentation. One drawback is a low rate limit, which is fine for prototyping but won't support scaling my app.

While writing this post I did more searching and found an open source API [Podcast Index](https://podcastindex-org.github.io/docs-api/#overview--example-code) that is free and does not have a rate limit. In the future I'll switch to this so I can power a typeahead search experience.

### Figuring out how to use the API

I started by carefully reading through the [documentation on search construction](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html), keeping an eye out for how I might filter to only Podcast results. In this case it was by appending `?media=podcast` to the URL. I also appended `&limit=10` to make it easier to read through exampe results while testing.

I continued poking around and found [documentation on the results](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/UnderstandingSearchResults.html) and used this to compare to the example data I was getting back from the API.

The Podcast results had some different fields and by looking at examples I identified `feedUrl` as the field containing the URL of the RSS feed.

I ended up with this fairly simple Python code to retrieve Podcast search results:

```python
base_url = 'https://itunes.apple.com/search?media=podcast&limit=10&term='        
query = request.args.get('q')
url = base_url + query
r = requests.get(url)
data = json.loads(r.text)
results = [
    {"itunes_id": r.get('collectionId'), 
    "title": r.get('collectionName'),
    "image_url": r.get('artworkUrl600'),
    "itunes_url": r.get('collectionViewUrl'),
    "feedUrl": r.get('feedUrl')} 
    for r in data[0]['results']] 
```

## Understanding podcast RSS/XML feeds

### The difference between RSS and XML

Before I started to use RSS feeds I did some background research to learn more about them. It's always helpful to start with a broad technology understanding before using it in a project.

RSS stands for "Rich Site Summary" and XML stands for "Extensible Markup Language".

RSS is a specific standardized use case of the more generic XML. It was invented to help distribute web content updates more easily to end users.

### What are podcast RSS standards?

There aren't universal podcast RSS standards, but most publishers will likely follow the [requirements](https://podcasters.apple.com/support/823-podcast-requirements) dictated by major platforms like Apple and Android.

The key info I learned from the requirements is that I'll need to get the audio file URL from an `<enclosure>` tag.

What the documentation didn't explain, but that I found by searching and looking at example RSS feeds is that each episode's data is contained in an `<item>` tag.

## Parsing XML with Python

Before trying to parse XML I did some background reading to learn more about it. I find W3 offers good high level summaries of concepts (see their [XML overview](https://www.w3schools.com/xml/xml_whatis.asp)).

I then started searching for how to parse XML in Python. There were a few different options, but I decided to start with the already included xml module.

The first step is importing the ElementTree class and using `fromstring()` which returns an Element object.

```python
import xml.etree.ElementTree as ET
root = ET.fromstring(r.text)
```

After that we can use the `findall()` method and loop through the returned list using `find()` to extract specific elements.

```python
items = root.findall('.//item')
for item in items[0:10]:
    title = item.find('title').text
    download_link_element = item.find('enclosure')
    mp3 = download_link_element.get('url') if download_link_element is not None else ''
```

A couple of things to point out in that code:

1. `.//item` is using an xPath syntax (see [documentation](https://docs.python.org/3/library/xml.etree.elementtree.html#xpath-support)). The `.` selects the current node (which is the root) and `//` searches through all subelements in the tree. 

2. `find()` returns the first matching child element. You can then access the text content on it with `.text`.

3. The audio file URL is stored as an attribute on the element so you need to use `get()`

4. I discovered through trial and error that occasionally the enclosure element did not exist, so I had to add an if clause to guard against that.

## Playing audio on the web

The easiest part ended up being writing the code to play the audio. The react code below shows the required code.

```html
<audio controls autoPlay title={episode.title}>
    <source src={episode.source_url} type="audio/mpeg" />
</audio>
```

A few things to add detail on:

1. There are some attributes to control the appearance and behavior of the audio element. I used `controls` to show play/pause/etc. and `autoPlay` to start playing the file automatically

2. Inside the audio element you add one or more source elements which link to the file source.

## Conclusion

I hope you found the above walkthrough helpful. Keep in mind that along the way there was a lot of searching, reading documentation, and mostly a lot of testing and debugging. Good luck on your project!
