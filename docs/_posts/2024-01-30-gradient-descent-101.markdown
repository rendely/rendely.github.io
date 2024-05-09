---
layout: post
title:  "Neural Networks and Gradient Descent 101"
date:   2024-01-30 00:00:00 -0700
categories: AI
---

## What you'll learn in this post

My aim in this post is to give readers a better intuitive understanding of two fundamental building blocks used by most modern AI applications today: neural networks and gradient descent. If you can understand very basic Python code you'll be able to follow along. Even if you don't know Python, you should walk away with a better grasp of some of the core magic behind AI.

Note: I have heavily oversimplified this in order to make it more approachable to beginners and even non-technical readers. See the recommended reading in the last section for more advanced materials I recommend.

## What is Artificial Intelligence (AI)?

If you really simplify down what AI is -- it's making predictions based on patterns learned from example data. As a human you are probably familiar with "predicting" that larger homes are more expensive. Given enough example data an AI can be trained to make similar predictions.

## What is a neural network?

The name "neural network" is inspired by the structure of the human brain. Each neuron takes an input and produces an output. If you connect enough of these neurons together in more complex structures you get more sophisticated intelligence out of it.

Imagine a single neuron: you input the size of a house, and it outputs the price. You can then make it smarter by adding more neurons, which let you input things like the location, the number of bedrooms, etc. And as you add more neurons and connect them in the right way, this system starts to act more like a human brain and make more accurate predictions of the price of a home given multiple factors.

## What is gradient descent?

Continuing the example of a single neuron that predicts the price of a house based on its size: how do we teach the neuron what the "exchange rate" is between the two? E.g. if the formula is price = Y x square feet, how do we figure out what "Y", our exchange rate is?

This is where gradient descent comes in. We start with a random number for Y, and then use our training data to teach the AI what the exchange rate is.

Let's pretend our training data looks like this:
| House | Price | Square Feet |
| ----- | ----- | ----------- |
| 1 | $200k | 1000 sq ft |
| 2 | $400k | 2000 sq ft |
| 3 | $800k | 4000 sq ft |

And let's start our value of Y at 100

"Gradient" has a more specific mathematical definition, but for our purposes we'll define it as the rate of change. In the case of machine learning 

## Basic neural "network" in Python

## Basic gradient descent in Python

## Conclusion & recommended reading


