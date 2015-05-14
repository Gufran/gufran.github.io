---

layout: post_simple
title: Magic Is Bad
permalink: post/magic-is-bad
excerpt: "I and a couple other friends were out on vacation and having fun in [Rishikesh](http://en.wikipedia.org/wiki/Rishikesh), It was summer of 2010 I believe. We did everything a Man on vacation has to do, but there is this one thing I still remember as if it happened yesterday."

date: 2015-05-15

tags: 
  - "Lesson"
  - "Concept"
  - "Software Design"
  - "Tips"

---

I and a couple other friends were out on vacation and having fun in [Rishikesh](http://en.wikipedia.org/wiki/Rishikesh), It was summer of 2010 I believe. We did everything a Man on vacation has to do, but there is this one thing I still remember as if it happened yesterday.

On the outskirts, going up the hill, there was a [Dhaba](http://en.wikipedia.org/wiki/Dhaba). I dont remember how we ended up there, but now that we were there and it was a hot day we ordered some cold drinks and sat down. My friend Amresh pulled out a deck of cards and asked if we wanted to play. Well, it was a hot, lazy day, and we were tired too, I announced I didn't feel like playing cards, and so did 3 other buddies.

Now there sat Amresh with his deck of cards, shuffling through it slowly, lost in his dazy thought right when a truck pulled over.  

If you've ever been to Rishikesh you'd know that most part of the river Ganga is mined for sand and stone, and this truck was carrying sand. Anyway, so the truck pulled over and out came 3 guys, the driver, short, skinny, sweating guy wearing a vest and knickers, a normal looking guy - who most probably was the helper, and this other guy with a flat face, we later found out He was mute and deaf.  
They came over, ordered _chai_, lit cigarettes and sat down, except for the _flat face_ guy. He was kinda watching the mountains and the river, and lost in his thoughts. The driver and the helper guy started talking about their stuff and this _guy with a flat face_ came over to Amresh and pointed towards the deck of cards, Amresh asked him if He wanted to play a game, and He said nothing. Amresh handed him the deck.

At this point this guy had my attention. In fact we all were attentive towards him, five of us, the driver and the helper guy. This guy did a good shuffle through cards, pulled out 4 cards one after another and put them on the table - face down. He handed back the rest of the deck to Amresh and went back to watching the mountains and river as if nothing happened. At this point I was really curious about the whole situation, and I think every other person shared the same feeling. So, Amresh turned the cards over and, lo and behold, they were all Aces!  
An impressive trick out of nowhere. I was impressed. The truck driver and the helper just chuckled and resumed their conversation.

I personally dont have any experience with card tricks, and I haven't seen many in person either so at this point I was really curious and blown away. I asked Amresh for the deck and started to look through it, all five of us analyzed the deck for good 10 minutes. The deck was complete, full sets of four suites, no mark on any card and nothing else that might have stood out. This guy was a pro.  

So, that got the conversation started between us and the trucker guys, the driver told us that our guy was mute and deaf and it was a usual thing for him to pull a trick out of nowhere. That was sad, He didn't knew sign language either, not that anyone of us did but that would have been a hope nonetheless, at least we could have recorded a video and have it translated by someone who knew sign language at a later time.

After about an hour, when these guys got up to leave, He came over, asked for the deck and did it again. All four Aces, one more time.

To this day I have no idea how He did it but he taught me a good lesson that day - Magic is bad.

1. By definition, you cannot understand magic.
2. Even if you can, your comprehension is the extent of what you can understand.
3. If the person is not telling you or is no longer around to teach you, you'll never know how it is done.

And same goes for your code.  
A code with magical behavior is not good, it gets the work done, sure, but it is not maintainable and not everyone can understand it. There will come a time when you'll not be around and a less skilled and experienced person than you will inherit the code, and at that time this mighty, magical code of yours, which you take pride for writing, will have to be torn apart for the sake of development. It will be destroyed, and you will be cursed and cussed and forgotten.

So here is my advise for you. If you receive a comment about your code which has the word _'clever'_ in it, you have an obligation to go back and refactor until the cleverness is all gone. The behavior of your code should be immediately obvious just by looking through the code, If one need to chase the method calls and remember a bunch of variable only to figure out what is going on then it is your responsibility to make it dead obvious. Refactoring is the key.  
A good programmer write boring code. Full of boredom. Dull statements, no surprises, no tricks, no special cases and no side effects. Boring code is the easiest to debug, to verify, and to explain. Magic is fun and exciting but a boring code is what everyone want to see, inherit and work with. To quote [Tef](http://programmingisterrible.com/about)

 > A boring code doesn't use global state and has very precise effects. Boring code will only do what is asked of it and does not rely on implicit behaviors. Implicit behaviors means there is more to keep in your head at any one time, and code that relies on them become harder to reason about, both locally and globally. When the behavior changes, it will be a painful process to migrate code from one set of implicit behaviors to another.

The _flat faced_ guy has intrigued me for a lifetime but that is only because He did a card trick, had it been a piece of code He had written I'd have punched him square in the face and ran as fast as I can.
