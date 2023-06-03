---
layout: post
title:  "Phase 2 Blog Post: React Beginner Tips"
date:   2023-04-28 18:47:10 -0700
categories: jekyll update
---

## Overview

In this blog post we'll go over some of my learnings from my first React project that could be helpful for beginners. These are practical examples of the types of challenges needed to build a functioning app.

## About my first React Project

My first React project is a Study Card app. Users can manage multiple collections of study cards, and enter a review mode to test their knowledge and practice.

![Study Card App Screenshot]({{ "/assets/img/card_edit.png" | relative_url }})

## Tip 1: How to use Semantic UI

I wanted to practice using a package of standard UI components so I could build a more usable and visually appealing app. I decided on [Semantic UI for React](https://react.semantic-ui.com/).

To get started I'd recommend exploring the [Layout Examples](https://react.semantic-ui.com/layouts) page, which show a lot of components and how they can be used together.

After that you can browse the page's left side nav menu or use the search to find specific components you think you'll want to use. In my case I found a [Card component](https://react.semantic-ui.com/views/card/) I could use for the study cards as well as the [Form component](https://react.semantic-ui.com/collections/form/) used for adding and editing cards.

In addition to the numerous examples you can find scrolling the detail page of each component, I recommend toggling to `Props` at the top of the page to see the spec describing all the props for that component.

## Tip 2: Editable study cards

Once a user has already created cards, I also wanted them to be easy to edit later. At first I built it so that editing would navigate to an edit page, but I realized it was jarring as a user to go back and forth between those two views. I decided instead to let users edit the card direclty in place for better usability.

To do this, each card has state to track if it's being edited or not. And if it is I render a form version of the card. What's great about this approach is the `CardForm` component is the same one I used for letting users add a new card, so it serves a dual purpose.

```javascript
 if (isBeingEdited) return <CardForm question={card.question} answer={card.answer} onSubmitCard={handleEdit}/>
  else return (
    <Card>
     ... JSX for regular card goes here ...
    </Card>
```

## Tip 3: Keyboard shortcuts

In the study card app, a user might be reviewing hundreds of cards in one sitting. Instead of the user needing to click around hundreds of times we can improve the user interface with keyboard shortcuts. I decided to use the down arrow key to reveal the answer, as this mirrored the UI of the answer appearing below the question. I also decided that the left and right arrows could mark the answer as known or unknown. With these keyboard shortcuts users can effortlessly go through dozens or even hundreds of cards very quickly.

I first wrote the function which would handle the `keydown` event. Calling the corresponding function and arguments for the three keypress options.

```javascript
function handleKeyDown(e) {
  if (e.code === 'ArrowDown') setShowAnswer(true)
  else if (e.code === 'ArrowRight') handleResult(true)
  else if (e.code === 'ArrowLeft') handleResult(false)
};
```  

Then, I decided to use the `useEffect` hook to perform the side effect of directly updating the DOM by adding an event listener the first time the component is mounted. (Using eventListener here is a mistake in React, which I will explain shortly)

```javascript
useEffect(() => {
  document.addEventListener('keydown', handleKeyDown)}, []);
```

However, this led to a bug where the review got stuck showing the second card and trying to send update fetch requests on the initial card, over and over. That's because the event listener function `handleResult` was still operating on the first `card` prop that was being passed to the component. To add a new eventListener each time the `card` prop was updated I added it as a depedency.

```javascript
useEffect(() => {
  document.addEventListener('keydown', handleKeyDown)}, [card]);
```

Now I had a new bug, where after reviewing a card it would skip forward several cards at a time, skipping more and more cards in each subsequent step. That's because I wasn't cleaning up the first event listener, so they were stacking up. To fix this I added a return function at the end for effect cleanup.

```javascript
useEffect(() => {
  document.addEventListener('keydown', handleKeyDown);
  return (() => document.removeEventListener('keydown', handleKeyDown));
  }, [card]);
```

And with that it was working perfectly! Except that I later learned using eventListener like this is a big mistake in React for two reasons:
 1. We already have access to the eventListener through the JSX itself, so it's redundant
 2. We are directly modifying the DOM, when React actually wants to use a virtual DOM instead.

So how do we fix this to work the React way? We use the onKeyDown event handler and wrap our component in a focusable div by using tabIndex. With useRef and useEffect we can autofocus this element when the component mounts.

```javascript
const cardRef = useRef(null); 
useEffect(() => {cardRef.current.focus();},[]);

...ommitted code...

<div onKeyDown={handleKeyDown} tabIndex={0} ref={cardRef}>
...rest of component here...
</div>
```

## Tip 4: Make new component files quickly

It can be tedious to create a new component file, add the boilerpolate React code, and write the boilerplate import code. Especially if you're creating a lot of new components for a project.

One way to speed this up is to automate some of the steps in bash by creating a bash function. Depending on your OS, you can add this to a ~/.bashrc file or ~/.zshrc file.

The example bash function below creates the component file and copies the import statement to your clipboard. Any time you want to create a new component you simply navigate to the components folder and type `component MyNewComponent`.

```bash
component(){
#Quickly create a new react component file
  component="$1"  # The component is the first argument to the function
  current_dir=${PWD##*/} #Get current directory
  if [ "$current_dir" != "components" ]; then  # Check if we're already in the components directory
    echo "Please navigate to the 'components' directory first."
    return
  fi

  if [ -e "$component.js" ]; then  # Check if the file exists
    echo "$component.js already exists."  # If it does, print a message saying so
  else
    touch "$component.js"  # If it doesn't, create the file
    cat <<END_TEXT > "$component.js"  # Add the text to the file
import React from 'react'

function $component(){
  return ()
}

export default $component

END_TEXT
    echo "Created $component.js and copied import statement to clipboard"
    echo "import $component from './$component';" | pbcopy
    code -r "$component.js"
  fi
}
```
