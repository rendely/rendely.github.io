---
layout: post
title:  "Phase 4 Blog Post: Date types, full stack from SQLAlchemy to React"
date:   2023-08-18 18:47:10 -0700
categories: flatiron
---

## Overview

My fourth project in the Flatiron course was a [meal planning app](https://github.com/rendely/phase-4-project-meal-planner). I needed a way to let users plan meals for specific dates, which required figuring out how the Date type would work in 3 distinct areas of my code: (1) my database via SQLAlchemy, (2) my flask backend, and (3) my React frontend.

In this blog post I'll explain how the Date type is used across the entire stack and some helpful methods I learned along the way.

## Date type in SQLAlchemy

Let's start with SQLAlchemy, which in my case was connected to a simple sqlite table. The first question I had to answer was whether to use Date or Datetime. Since I only needed the year, month and day and not the time I decided to use Date.

Here's how you create a Date column in SQLAlchemy. 

```python
date = db.Column(db.Date)
```

This is equivalent to Python's [datetime.date()](https://docs.python.org/3/library/datetime.html#date-objects) object according to the [SQLAchemy type basics](https://docs.sqlalchemy.org/en/20/core/type_basics.html#sqlalchemy.types.Date:~:text=sqlalchemy.types.Date-,A%20type%20for%20datetime.date()%20objects.,-Members).

One thing to note is that sqlite [_technically_](https://www.sqlite.org/draft/datatype3.html) doesn't have a Date type, so it instead either stores it as text, real or an integer.

You can verify how it's stored in sqlite3 by interacting directly with the database as shown below:

```bash
# Open sqlite CLI
$ sqlite3 instance/app.db

# Show list of tables
sqlite> .tables
# alembic_version    meal_plans         meals_ingredients
# ingredients        meals              users  

# Show schema of specific table
sqlite> .schema meal_plans
# ...
# date DATE NOT NULL, 
# ...

# Show the actual type of that column
sqlite> select typeof(date) from meal_plans limit 1;
# text
```

So far so good, defining the model was actually pretty straightforward.

## Date type in Flask / Python

To work with the Date type in Python we use the [datetime module](https://docs.python.org/3/library/datetime.html) which is included with Python. If you pay attention to nothing else in this post, remember that timezone information is what introduces a lot of the complexity and unexpected behavior in datetime. Read the docs carefully and try to test edge cases near boundaries to ensure your code is working correctly.

We'll start with a basic instantiation of a date object:

```python
import datetime
d = datetime.date.today()
d
#datetime.date(2023, 8, 19)
print(d)
#2023-08-19
```

Because my app organizes the meal plan around the current week, I always want to show Monday to Sunday of the current week. To get this behavior working in my seed.py file to populate test data, I needed to get the date of the Monday of this week.

The weekday() method returns the day of the week as in int with Monday == 0. Here's how that code looks:

```python
today = datetime.date.today()
weekday = today.weekday()
monday = today + datetime.timedelta(-weekday)
```

I also needed to take dates that were posted to my API from the React app. Since I'm deserializing the JSON into a Python object I needed a way to convert the date string into a datetime.date() object. There isn't a method on the date class but the datetime class has one called strptime(). And it's easy to convert that to a date object with date().

The format codes are based on a 1989 C standard format codes, you can [see a list here](https://help.gnome.org/users/gthumb/stable/gthumb-date-formats.html.en). Just make sure you are consistent with what the React frontend is sending.

```python
data = request.get_json()
print(data['date'])
# '2023-08-18'
date = datetime.strptime(data['date'], '%Y-%m-%d').date()
meal_plan = MealPlan(date=date)
```

Those are the basics for using date in Python, but there is a lot more to learn depending on your use cases.

## Date type in React / Javascript

Let's switch gears now to the [Date built-in object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date) in Javascript. Unlike Python, Javascript Date objects are stored as time in milliseconds since the epoch, which is timezone agnostic.

I needed to do several things on the frontend with dates, so let's break it down into steps and show the code for each.

1. Figure out the first day and date of this week
2. Create an array of all seven days in this week starting on Monday
3. Convert those dates to something human readable

To figure out the first day of the week we take a similar approach as we did in Python by using a method to get the day of the week, in this case [getDay()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getDay) with Sunday == 0.

```javascript
const today = new Date();
// 2023-08-20T00:38:16.095Z
const currentDay = today.getDay();
// 6
const daysFromMonday = 1 -currentDay;
// -5
```

In order to offset the date we need to use the setDate() method that changes the day of the month. We can use that with our daysFromMonday int to get the start of the week and then iterate through a for loop to fill the the rest.

```javascript
const startDate = new Date(today);
// 2023-08-20T00:38:16.095Z
startDate.setDate(today.getDate() + daysFromMonday);
// 2023-08-15T00:38:16.095Z
const weekDates = [];
for (let i = 0; i < 7; i++) {
  const date = new Date(startDate);
  date.setDate(startDate.getDate() + i);
  weekDates.push(date);
}
// [
//   2023-08-15T00:42:17.355Z,
//   2023-08-16T00:42:17.355Z,
//   2023-08-17T00:42:17.355Z,
//   2023-08-18T00:42:17.355Z,
//   2023-08-19T00:42:17.355Z,
//   2023-08-20T00:42:17.355Z,
//   2023-08-21T00:42:17.355Z
// ]
```

The last step was creating a more human readable format of the date. We can use date's methods to extract the year, month and day and format them with a template placeholder. Note that getMonth is zero indexed. We use javascript String's [padStart](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padStart) method so we can always have 2 digits for the month and the day for values < 10.

```javascript
const year = date.getFullYear();
// 2023
const month = String(date.getMonth() + 1).padStart(2, '0');
// '08'
const day = String(date.getDate()).padStart(2, '0');
// '20'
return `${year}-${month}-${day}`;
// '2023-08-20'
```

And one final touch is to turn the day of the week into the names we are familiar with. We do that with a simple array index.

```javascript
const weekDays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
const dayName = weekDays[date.getDay()];
// 'Sunday'
```

## Conclusion

There are a lot of "gotchas" to getting dates working correctly, especially when working across two languages with different behaviors for timezones and 0-indexing. I hope this guide can help you get started more quickly, as well as point you to further resources for handling more complex cases.
