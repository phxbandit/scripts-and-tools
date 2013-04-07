#!/usr/bin/env python

from random import choice

f = open('stories.txt', 'r')
stories = []
for line in f:
    stories.append(line.strip())
print choice(stories)
