
---
layout: post
title:  "Phase 5 Blog Post: Podcast XML feeds"
date:   2023-11-13 12:00:00 -0700
categories: flatiron
---

My fifth project in the Flatiron course was a [Podcast app](https://github.com/rendely/phase-5-project-pawdcasts). I needed an API to find an up to date list of podcasts, as well as load XML feeds to get the list of available episodes.

In this blog post I'll explain how I went about that, starting from scratch to give you ideas about how you can get unblocked on a new project.

## Plan out what you need

First think through all the data needs of your project, working backwards to make the dependencies clear. In my case I wanted a few things:

1. **Audio file URLs:** Users should be able to play the audio of podcast episodes directly in the web app. So I knew I ultimately needed the URL of an audio file I could stream. From some quick searching I learned that almost all podcasts have these links in their public RSS feeds.

2. **Podcast episode feed:** I needed an up-to-date RSS feed of the episodes with the title, description and audio file of each episode, so users had enough info to decide what to listen to.

3. **Podcast directory API:** I needed an API that returned a list of podcast feeds so users could search for and choose podcasts to follow. It needed a thumbnail image, title and link to the RSS feed at a minimum.

## Finding a podcast API

### Which API to use

### Figuring out how best to utilize it


## Understanding podcast RSS/XML feeds

### The difference between RSS and XML

### What are podcast RSS standards?

## Parsing XML with Python

### XML in Python basics

### Edge cases

## Conclusion
