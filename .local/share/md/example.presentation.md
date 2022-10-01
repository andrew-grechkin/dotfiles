---
title: Example beamer presentation
author: Andrew Grechkin
date: November 02, 2022
theme: Dresden
output: beamer_presentation
toc: true
fig_caption: true

---
# In the morning

## Getting up

- Turn off alarm
- Get out of bed

## Breakfast

- Eat eggs
- ~~Drink coffee~~

# In the afternoon

## Working

![Image](https://www.markdownguide.org/assets/images/tux.png)

***

> a *lot* of work
>
> and **even** more
>
> **and _even_** more

## Lunch

```perl
use v5.28;
use strict;
use warnings FATAL => qw(utf8);

our $VERSION = 1;
exit 42;
```

## Some diagrams 1

```mermaid
%%{
  init: {
    "flowchart": { "htmlLabels": false }
  }
}%%
flowchart TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```
<!---->

## Incremental bullets

>- Sandwich
>- Drink tea
>- one at a time (incrementally)

## Some diagrams 2

<!-- https://mermaid-js.github.io/mermaid/#/directives?id=directives -->
```mermaid
%%{
  init: {
    "theme": "dark",
    "fontFamily": "Sans-Serif",
    "logLevel": "info",
    "flowchart": {
      "htmlLabels": true,
      "curve": "linear"
    },
    "sequence": {
      "mirrorActors": true
    }
  }
}%%
sequenceDiagram
    participant Alice
    participant Bob
    Alice->John: Hello John, how are you?
    loop Healthcheck
        John->John: Fight against hypochondria
    end
    Note right of John: Rational thoughts <br/>prevail...
    John-->Alice: Great!
    John->Bob: How about you?
    Bob-->John: Jolly good!
```
<!---->

## Some diagrams 3

```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title Adding GANTT diagram functionality to mermaid
    section A section
    Completed task            :done,    des1, 2014-01-06,2014-01-08
    Active task               :active,  des2, 2014-01-09, 3d
    Future task               :         des3, after des2, 5d
    Future task2               :         des4, after des3, 5d
    section Critical tasks
    Completed task in the critical line :crit, done, 2014-01-06,24h
    Implement parser and jison          :crit, done, after des1, 2d
    Create tests for parser             :crit, active, 3d
    Future task in critical line        :crit, 5d
    Create tests for renderer           :2d
    Add to mermaid                      :1d
```
<!---->

# In the evening

## Dinner

| Order  |   Food    | Price of the food |
|--------|:---------:|------------------:|
| First  | Spaghetti |              10 € |
| Second |   Wine    |              20 € |

## Going to sleep

- Get in bed ^1^...~2~
- Count sheep 2---4
