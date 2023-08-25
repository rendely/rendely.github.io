---
layout: post
title:  "Phase 1 Blog Post: Tips and tricks for sorting arrays"
date:   2023-04-01 18:47:10 -0700
categories: flatiron
---

In this blog post we'll start by walking through the very basics of how to sort Arrays in Javascript and what to watch out for. <!--more-->We'll then build on those fundamentals to handle several of the most common scenarios you'll face. These scenarios include sorting alphabetically, sorting numerically, sorting objects and, lastly, custom sorting rules. 

## Array sorting basics

To understand basic sorting, let's start with an array of strings and see what we get.

```javascript
words = ['bat', 'dog', 'cat', 'rat']
console.log(words.sort())
// [ 'bat', 'cat', 'dog', 'rat' ]
```

Great! This `sort` method seems to just magically work! How about we try it on some numbers next?

```javascript
numbers = [20, 10, 100, 50];
console.log(numbers.sort())
// [ 10, 100, 20, 50 ]
```

Huh? Why is `100` showing up between `10` and `20` and not at the end? 

Reading the documentation you'll see that the `sort` method has an optional parameter `sort(compareFn)`. And further, [if compareFn is not supplied, all non-undefined array elements are sorted by converting them to strings and comparing strings in UTF-16 code units order.](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort#:~:text=If%20compareFn%20is%20not%20supplied%2C%20all%20non%2Dundefined%20array%20elements%20are%20sorted%20by%20converting%20them%20to%20strings%20and%20comparing%20strings%20in%20UTF%2D16%20code%20units%20order.)

The sort function is treating our list of numbers as a list of strings instead. How can we fix that?

## Sorting numeric values

To sort numeric values the way we want, we'll need to write our own compare function. The full documentation is [here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort). Below is a briefly explained version of a simple compare function. 

```javascript
//sort calls the compare function and passed two arguments, a and b
//these are the two elements from our list being compared
function sortByNumber(a, b) {
  //convert each of them to a Number type 
  aVal = Number(a);
  bVal = Number(b);
  //if a is bigger we return > 0 to sort a after b
  if (aVal > bVal) return 1;
  //if b is bigger we return < 0 to sort b after a
  if (aVal < bVal) return -1;
  //else keep the original order
  return 0;
}
```

And the moment of truth...
```javascript
console.log(numbers.sort(sortByNumber))
// [ 10, 20, 50, 100 ]
```

Hurray! It works!

## Sorting by ascending and descending

What if we wanted to sort the numbers in descending order instead? We could write a separate compare function, but that would fail our DRY (Don't Repeat Yourself) principle. Let's see how we can extend the functionality of our compare function.

```javascript
//Factory function that returns the compare function with the behavior we want
//The asc bool parameter will determine whether to sort ascending or descending
function sortByNumberAsc(asc = true) {
  return function (a, b) {
    aVal = Number(a);
    bVal = Number(b);
    //use a ternarny to change the sort direction based on the value of the asc bool
    if (aVal > bVal) return asc ? 1 : -1;
    if (aVal < bVal) return asc ? -1 : 1;
    return 0;
  }
}
```

And testing to see if it works:

```javascript
console.log(numbers.sort(sortByNumberAsc))
// [ 10, 20, 50, 100 ]
console.log(numbers.sort(sortByNumberAsc(false)))
// [ 100, 50, 20, 10 ]
```

Amazing! We can now quickly sort numeric values in either ascending or descending order.

So far we've just been sorting a list of values, but frequently in javascript we'll need to sort objects. How will we do that?

## Sorting arrays of objects

First let's create an example dataset to help us work through these examples. Let's create a cars dataset which has several cars. For each object we'll have the name, class and price of the car. 

```javascript
cars = [
  {
    "name": "Luxo",
    "class": "Sedan",
    "price": 70000
  },
  {
    "name": "Alpha",
    "class": "Sedan",
    "price": 65000
  },
  {
    "name": "Thunder",
    "class": "Sports",
    "price": 90000
  },
  {
    "name": "Viper",
    "class": "Sports",
    "price": 80000
  },
  {
    "name": "Fury",
    "class": "SUV",
    "price": 60000
  },
  {
    "name": "Juggernaut",
    "class": "SUV",
    "price": 55000
  }
]
```

If we were to use `sort()` without a compare function or use one of our earlier compare functions we'd be passing a car object for `a` and `b` and it wouldn't really make sense to compare two objects to each other. What we actually want to do is take a specific value from both objects and compare those values. For example, we might want to take the price of the car object and sort all the cars based on their prices.

Let's see how we can modify our compare function to use a value from the object:

```javascript
//Add a new parameter: key
function sortByNumberOnKeyAsc(key, asc = true) {
  return function (a, b) {
    //Use key to extract a specific value from the objects we're comparing
    aVal = Number(a[key]);
    bVal = Number(b[key]);
    if (aVal > bVal) return asc ? 1 : -1;
    if (aVal < bVal) return asc ? -1 : 1;
    return 0;
  }
}
```

With this new compare function we can choose any key from our object to use for sorting. Since it's converting the values to a Number we should pick a key that is numeric. Let's sort by price:

```javascript
console.table(cars.sort(sortByNumberOnKeyAsc('price')))
// ┌─────────┬──────────────┬──────────┬───────┐
// │ (index) │     name     │  class   │ price │
// ├─────────┼──────────────┼──────────┼───────┤
// │    0    │ 'Juggernaut' │  'SUV'   │ 55000 │
// │    1    │    'Fury'    │  'SUV'   │ 60000 │
// │    2    │   'Alpha'    │ 'Sedan'  │ 65000 │
// │    3    │    'Luxo'    │ 'Sedan'  │ 70000 │
// │    4    │   'Viper'    │ 'Sports' │ 80000 │
// │    5    │  'Thunder'   │ 'Sports' │ 90000 │
// └─────────┴──────────────┴──────────┴───────┘
```

What if we want to sort by car name instead? We can create a compare function without the `Number` function:

```javascript
function sortAlphaByKeyAsc(key, asc = true) {
  return function (a, b) {
    aVal = a[key];
    bVal = b[key];
    if (aVal > bVal) return asc ? 1 : -1;
    if (aVal < bVal) return asc ? -1 : 1;
    return 0;
  }
}

console.table(cars.sort(sortAlphaByKeyAsc('name')));
// ┌─────────┬──────────────┬──────────┬───────┐
// │ (index) │     name     │  class   │ price │
// ├─────────┼──────────────┼──────────┼───────┤
// │    0    │   'Alpha'    │ 'Sedan'  │ 65000 │
// │    1    │    'Fury'    │  'SUV'   │ 60000 │
// │    2    │ 'Juggernaut' │  'SUV'   │ 55000 │
// │    3    │    'Luxo'    │ 'Sedan'  │ 70000 │
// │    4    │  'Thunder'   │ 'Sports' │ 90000 │
// │    5    │   'Viper'    │ 'Sports' │ 80000 │
// └─────────┴──────────────┴──────────┴───────┘
```

Excellent! We can now sort a list of objects based on a string value or a number value. What else could we possibly need? Well...

## Creating custom sorting rules

What if we wanted to sort our cars by the car class, but we want it to be in a specific order that is not alphabetical or numeric? For example, we want to show all the sedans first, then SUVs, and finally sports cars.

Turns out it's pretty easy to do this. We just need one intermediate step to convert the strings into a rank value that we can then sort numerically. (We could also use an alphabetical ranking system).

```javascript
// Sort Sedans first, then SUVs, then Sports
// Take the car class string and return a rank value for sorting
function rankClass(carClass){
   switch(carClass){
    case 'Sedan': return 1;
    case 'SUV': return 2;
    case 'Sports': return 3;
   }

}

//Updated compare function to use the value returned by rankClass()
function sortByClass(a,b) {
    aVal = rankClass(a['class']);
    bVal = rankClass(b['class']);
    if (aVal > bVal) return 1;
    if (aVal < bVal) return  -1;
    return 0;
}
```

And the moment of truth...

```javascript
console.table(cars.sort(sortByClass))
// ┌─────────┬──────────────┬──────────┬───────┐
// │ (index) │     name     │  class   │ price │
// ├─────────┼──────────────┼──────────┼───────┤
// │    0    │   'Alpha'    │ 'Sedan'  │ 65000 │
// │    1    │    'Luxo'    │ 'Sedan'  │ 70000 │
// │    2    │    'Fury'    │  'SUV'   │ 60000 │
// │    3    │ 'Juggernaut' │  'SUV'   │ 55000 │
// │    4    │  'Thunder'   │ 'Sports' │ 90000 │
// │    5    │   'Viper'    │ 'Sports' │ 80000 │
// └─────────┴──────────────┴──────────┴───────┘
```

Wow! This is looking really good! Unfortunately the price sorting is a bit confusing. The sedans are priced low to high, but the other two categories are priced high to low. What if we wanted to sort by car class AND have the cars within each class sorted by price?

Would we need a really complicated compare function that somehow uses both the class and price values? Luckily, not. We can actually chain multiple sort methods and reuse the compare functions we already created:

```javascript
console.table(cars.sort(sortByNumberOnKeyAsc('price')).sort(sortByClass))
// ┌─────────┬──────────────┬──────────┬───────┐
// │ (index) │     name     │  class   │ price │
// ├─────────┼──────────────┼──────────┼───────┤
// │    0    │   'Alpha'    │ 'Sedan'  │ 65000 │
// │    1    │    'Luxo'    │ 'Sedan'  │ 70000 │
// │    2    │ 'Juggernaut' │  'SUV'   │ 55000 │
// │    3    │    'Fury'    │  'SUV'   │ 60000 │
// │    4    │   'Viper'    │ 'Sports' │ 80000 │
// │    5    │  'Thunder'   │ 'Sports' │ 90000 │
// └─────────┴──────────────┴──────────┴───────┘
```

And voila! We have our data sorted by class and by price. Notice that we do the price sorting before the class sorting.

## Conclusion

Hopefully these examples are a helpful introduction to sorting in Javascript and provide some code snippets that will cover many of the basic and intermediate sorting cases you'll need to solve for.
