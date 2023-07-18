---
layout: post
title:  "Phase 3 Blog Post: Python database stack with SQL Alchemy and Alembic"
date:   2023-07-11 18:47:10 -0700
categories: flatiron
---

## Overview

As a beginner programmer, I recently built my first [command line tool](https://github.com/rendely/phase-3-project-CLI) in Python using SQLAlchemy and Alembic. In this post I'll share some additiona research I did to learn more about these technologies.

## Python

### Why use Python?

There are several compelling reasons to use Python for your application:

1. The syntax tends be easier to pickup and read, relying on whitespace rather than characters like brackets and semicolons.

2. There are thousands of modules available in the [Python Package Index (PyPI)](https://pypi.org/) powering use cases in web development, databases, analysis, and many more.

3. There is a large community using Python, making it easier to find documentation, tutorials, debugging help, etc.

4. It's interpreted and uses dynamic typing which makes prototyping faster and easier.

### When to use an alternative?

While Python has many strengths, there are always tradeoffs that might lead you to prefer a different language. For example, a compiled language like C could give better performance and be more robust with type checking. Javascript might allow you to develop both the frontend and backend in the same language. Mobile development tends to happen in Swift or Java/Kotlin for better performance and ecosystem support.

## SQL Alchemy

### What is it? Why use it?

[SQLAlchemy](https://www.sqlalchemy.org/) is a Python specific toolkit for Object Relational Mapping. Essentially it translates between the Python objects used in your code and the database storing your data. By abstracting away the database interactions the same Python code can work for multiple different types of databases. It also simplifies the process of manipulating the database with standard Python object syntax.

### Mini tutorial

There is a great [quickstart tutorial](https://docs.sqlalchemy.org/en/20/orm/quickstart.html) on the SQLAlchemy site. To give a quick preview of what the final working code can look like, here are some snippets from a final working project:

This Python code defines a User object that can have a name attribute and a trips attribute. It also defines the Trip object with name, year and users attributes. Both of these inherit the Base class from SQLAlchemy which will do the magic of creating a corresponding table in the database.

```python
class User(Base):
    __tablename__ = 'users'

    id = Column(Integer(), primary_key=True)
    name = Column(String())
    trips = relationship('Trip', secondary=user_trip, back_populates='users')

class Trip(Base):
    __tablename__ = 'trips'

    id = Column(Integer(), primary_key=True)
    name = Column(String())
    year = Column(Integer())
    users = relationship('User', secondary=user_trip, back_populates='trips')
```

Creating and interacting with User objects starts to look just like traditional Python syntax, with one small addition of a [Session object](https://docs.sqlalchemy.org/en/20/orm/session_basics.html) to allow for committing to the database. Here is an example of creating a new User and adding a Trip to their trips attribute.

```python
new_user = User(name='Albert')
new_trip = Trip(name='Europe', year='2023')
new_user.trips.append(new_trip) 
session.commit()
```

What if you don't want to create a new User but you want to retrieve one from the database? You can use the [Session query method](https://docs.sqlalchemy.org/en/14/orm/query.html) to retrieve data.

```python
# gets an array of all users from the db
all_users = session.query(User).all()

# gets the first (limit 1) result of users filtered by User.id == 1
user_by_id = session.query(User).filter_by(id = 1).first()
```

## Alembic

### What is it? Why use it?

[Alembic](https://alembic.sqlalchemy.org/en/latest/) is a database migration tool, designed specifically for SQLAlchemy. It enables you to do version control on your database schema. This [Stack overflow post](https://stackoverflow.com/questions/30425214/what-is-the-difference-between-creating-db-tables-using-alembic-and-defining-mod) offers a good explanation of why that is important. TL;DR is that as you start updating your database schema and are working across multiple environments, it becomes complicated to keep your model definition in the code consistent with the database. Alembic makes it easy to keep everything in lockstep.

### Mini tutorial

Without walking through the detailed code for using Alembic, I'll summarize the key conceptual steps that take place. The [Alembic tutorial](https://alembic.sqlalchemy.org/en/latest/tutorial.html) is a great place to get the full details.

1. Create a migration environment (very similar to git init)
2. Modify the environment configuration files for the database you are using
3. Create an initial revision in Alembic (similar to a first commit)
4. Run the actual migration with `almebic upgrade head`

At this point your database will be created (if it wasn't already). After this, let's say you define some new models like the User model from earlier in this tutorial. Your next steps would be the following:

5. Create a new revision in Alembic, with code like `alembic revision --autogenerate -m '<comment here>'`
6. Run the migration `almebic upgrade head`

You'll now have the new table you defined created in the database. Rinse and repeat!

## Conclusion

In conclusion, we used Python for its ease-of-use and robust ecosystem support. SQLAlchemy enabled us to write more classic Python object code and have that mirrored in the database of our choosing. Alembic made it simple to update our data models overtime in Python and keep our databases in sync.
