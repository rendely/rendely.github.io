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

Continuing the example of a single neuron that predicts the price of a house based on its size: how do we teach the neuron what the "exchange rate" is between the two? E.g. if the formula is `price = Y * square feet`, how do we figure out what "Y", our exchange rate is? (In AI terms we call this exchange rate a "weight")

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

## Gradient descent and back propagation deep dive

In the housing example just now we very arbitrarily picked how much to change our Y variable to try and find the minimum loss. But the magic of gradient descent is we can do this in a reliable and scalable way mathematically, so no eyeballing and guessing is needed.

Each training loop is divided into a "forward" pass, and a "backward" pass. In the forward pass we just calculate the predicted output (in this case the house price) and see how far off we are. In the backward pass we take that loss and figure out how much to adjust our weights, in this case "Y".

We use a bit of calculus to figure out how much to change Y based on the size of the error. This is called back propagation. And to figure out how much error to back propagate we look at the gradient of how the price varies with respect to changes in Y.

Let's re-write our formula as `P = Y*S`

To get the gradient we take the derivative d/dY which is equal to S (the square footage).

And because we want to slowly move towards the right value without stepping past it, we have a step size which is a fraction like 0.01 that we multiply by that gradient.

Revisiting our example above. With Y = 100, our gradient was 1000 and so we take a step of 1000 * 0.01 = 10. Changing Y to 110. And we'd keep taking these steps until we can no longer make the error smaller.

## Basic neural "network" in Python

That was somewhat complicated to follow as a written example, let's see if this Python code example makes it easier to understand.

Our neuron is going to be a very simple linear formula, very similar to the example of estimating the housing price, but we're adding a constant "b": `y = m * x + b`

We'll initialize our neuron's weights ("exchange rates") randomly:

```python
m = random.random()
b = random.random()
```

And create some fake training data:

```python
x = [-4, -2, 0,1,2,3]
y = [-8,-4, 1, 2.2, 3.3, 5.3]
```

Next we're going to setup a very simple training loop:

```python
#let's initialize some variables to track our progress with every training pass (forward and back propagation)
losses = []
passes = 0

for _ in range(50):
    passes +=1

    # Iterate through the training data
    # We could randomly select but we are keeping it simple
    for i in range(len(x)):

        # Forward pass to calculate output
        # This is just y = mx + b for the current input data
        out = m * x[i] + b
        
        # Calculate the loss and keep track of it 
        loss = out - y[i]
        losses.append(loss)
        
        # Now the magic: backward propagation 

        # First we pick a step size 
        # There is a whole art form to picking this right
        # Basically it's how far we want to nudge our parameters each pass
        # Too large moves them faster but we might skip PAST the optimal value
        # Too small takes forever to train
        step_size = 0.01

        # Next we calculate the gradient of each parameter
        # Which is the derivative of how the loss changes compared to how the param changes
        # In other words, which direction do we need to move the parameter to minimize the loss
        # And how much do we need to move it (is it very sensitive or not)
        # We multiply the parameter gradient by the loss due to the chain rule to find the gradient with respect to the loss

        # Let's start with the gradient for parameter b
        # It's super simple, it's just 1 since it's a constant
        # dy/db = 1
        # Here's the math with the formula for a derivative        
        # b_grad_calc = ((m*x + b+h) -  (m*x + b)) / h 
                    # =  (m*x - m*x +b-b +h) / h
                    # =   h / h = 1
        b_grad = 1 * loss 

        # The gradient of m is also straightforward, it's just x
        # dy/dm = x
        # Here's the math with the formula for a derivative
        # m_grad_calc = (((m+h)x + b) - (mx + b)) / h
                    # = (mx +hx +b -mx - b ) / h
                    # = hx / x = x
        m_grad = x[i] * loss 
        
        # Now we do our backward propagation step
        # We adjust each parameter based on the step size and it's linear gradient
        # AKA we nudge the parameters in the direction that will decrease our loss
        m -= m_grad * step_size
        b -= b_grad * step_size

    # At the end of each pass through all the training data we'll calculate predictions and plot them
    # This shows us how close our model is to the real training data
    y_pred = [xi * m + b for xi in x]
```

And here is an animation showing how the "neuron" is trained step by step to make better predictions:

![alt text](../assets/img/sgd_line.gif)

The red line shows the predicted output for all values of x. Each time the line moves we are showing how the back propagation step adjusted the weights to be more accurate.

## Recap & recommended content

Hopefully this article helped you learn at a very basic level what is going on under the hood with AI. You are now familiar with the terms: neural network, gradient descent, forward propagation, back propagation, loss, weights and a few others.

Once again, this is oversimplified to the point of being borderline inaccurate. But I hope it helps build some intuition. To continue learning, I highly recommend starting with Andrej Karpathy's video series: [The spelled-out intro to neural networks and backpropagation: building micrograd
](https://www.youtube.com/watch?v=VMj-3S1tku0)