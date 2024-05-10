---
layout: post
title:  "Neural Networks and Gradient Descent 101"
date:   2024-01-30 00:00:00 -0700
categories: AI
---

## What you'll learn in this post

My aim in this post is to give readers a better intuitive understanding of two fundamental building blocks used by most modern AI applications today: (1) neural networks and (2) gradient descent. If you can understand very basic Python code you'll be able to follow along. Even if you don't know Python, you should walk away with a better grasp of some of the core magic behind AI.

Note: I have heavily oversimplified this in order to make it more approachable to beginners and even non-technical readers. See the recommended reading in the last section for more advanced materials I recommend.

## What is Artificial Intelligence (AI)?

If you really simplify down what AI is -- it's identifying patterns and making predictions based on data. You, as a human, are probably familiar with making "predictions" like guessing that a larger home is going to be more expensive. Given enough example data, an AI can be trained to make similar predictions.

## What is a neural network?

So how does AI make predictions? One example of how it's build is with a neural network.

The name "neural network" is inspired by the structure of the human brain. Each neuron takes an input and produces an output. If you connect enough of these neurons together in more complex structures you get more sophisticated intelligence out of it.

Imagine a single neuron: you input the size of a house, and it outputs the price. You can then make it smarter by adding more neurons, which let you input things like the location, the number of bedrooms, etc. And as you add more neurons and connect them in the right way, this system starts to act more like a human brain and make more accurate predictions of the price of a home given multiple factors.

## What is gradient descent?

Continuing the example of a single neuron that predicts the price of a house based on its size: how do we teach the neuron what the "exchange rate" is between the two? E.g. if the formula is `price = Y x square feet`, how do we figure out what "Y", our exchange rate is?

This is where gradient descent comes in. It's the process of minimizing the error of our prediction. Let's work through an example:

Let's pretend our training data looks like this:
| House | Price | Square Feet |
| ----- | ----- | ----------- |
| 1 | $200k | 1000 sq ft |
| 2 | $400k | 2000 sq ft |
| 3 | $800k | 4000 sq ft |

We start with a random number for Y, and then use our training data to teach the AI what the exchange rate is. Let's start our value of Y at 100 arbitrarily. Testing that for our first house we would multiply 100 by the 1000 sq ft and get an estimated price of $100k. That's too low. Our error is $100k, since that is how far off we are from the real price of $200k.

Since our estimate is too low, let's make Y bigger and set it to 150. Now we get $150k and only have an error of $50k.

Our estimate is still too low, but by a smaller amount so let's make it a little bigger and set Y to 175. Now we get $175k and our error is only $25k. We can keep doing this until the error is as close to zero as possible.

We are descending down the gradient of the size of the error until we minimize it. You'll notice we only used data from the first house. In reality for training you'd use the data from all the houses and find the value for Y that minimizes the error for predicting the price of any of them.

## Basic neural "network" in Python



## Basic gradient descent in Python

## Recap & recommended reading


