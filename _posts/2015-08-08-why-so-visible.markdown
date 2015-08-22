---

layout: post_simple
title: "Visibility In OOP"
permalink: "post/visibility-in-oop"
excerpt: "If you maintain at least one open source project you'll know how important it is to clearly define the behavioral specifications for your code.  
You can control every extension point in a project using five keywords and enforce the expectations. Stupid proof code will kick you in the butt every time you make a stupid decision. It will force you to think and wonder about stuff that you would never bother about otherwise."

date: 2015-08-22

tags: 
  - "Programming"
  - "Tips"
  - "Software Design"

---

My programming career goes all the way back to my first year in college when I started freelancing. All I knew about programming at that time was stuff I was taught in school, and a really bad cocktail of functional and object oriented language concepts. I also knew that you have these cheeky `public`, `private`, `protected` and `final` keywords in _almost every_ object oriented language to set the visibility of a method or variable. What I didn't know was, why would you ever need anything other than `public` visibility? I mean what's the point of a class variable if you can't even access it, right? OK, maybe you can use `protected` in some cases but `private`.. guuh! Why have two different keywords for similar functionality?

And then I learned things.  
I read a lot of books, so many coding horrors, a plethora of code, and I participated in conversations, asked questions and sometimes got yelled at, but in the end I learned so many cool things.  
Cool things that I wasn't sure I should share with anyone, because they'll yell at me and put up an argument about having opinions (_no shit, boy_).  
All that until I came across this talk by Marco Ocramius, [Extremely Defensive PHP](https://www.youtube.com/watch?v=vS0Nn_ncH-8), thanks to [Rahul](https://twitter.com/@librianrahul) for sharing it.  
In this talk Marco discussed extremely defensive programming practices in PHP; practices that work well for long lived projects. And this talk [inspired me](http://ocramius.github.io/extremely-defensive-php/#/15) a lot that I finally decided to write this blog post.

The gist of the talk is that you should be writing _stupid proof_ code. Code that can only be used in a way that you made it to be used for. No one should be able to use the code in any other manner than is specified. It's a really good talk and I recommend that you go ahead and watch the video.  
Marco covered a lot of ground on visibility and accessibility in his [blog post](http://ocramius.github.io/blog/when-to-declare-classes-final/), and I am going to put my thoughts on top of this very blog post.

I compiled a list of points made my Marco.

1. Prevent massive inheritance chain of doom
2. Encourage composition
3. Encapsulate properly
4. Work towards abstraction

Lets get started with this list. If you want to achieve most of it, I have four tips for you.

1. Make extensible class abstract
2. Make non abstract class final
3. Non abstract class can have only public or private members
4. Only abstract class can have protected members

### Make extensible class abstract.
Extending a class is a separate use case in its own. Most of the times you extend a non-abstract class you are going to violate *SRP*.  
Marking a class `abstract` takes away the responsibility of the class and you can only use it for functionality that is [truly re-usable in an _abstract_ sense](http://ocramius.github.io/extremely-defensive-php/#/37). This will force you to think about the concerns of your code and separate them.  
Inject dependencies instead of inheriting from them, and if you still believe that a class must extend from a non-abstract class, you need to re-factor this would-be-parent class and extract that logic which make you want to extend the class so desperately into an abstract class.

### Make non abstract class final.
Every class which is not abstract has its own concerns to deal with. When you extend it you are essentially adding concerns to the class. When you extend, the child class is now responsible for the concerns of its own _plus_ the concerns of its parent.  
Marking a class `final` tells the consumer to compose functionality, and it also restricts the level of accessibility to only public API, which ultimately make your code stupid proof.

### Non abstract class can have only public or private members.
If a class is not abstract, its responsibilities are assumed to be saturated, at least for the current cycle. What that mean is, that no one should be adding any more functionality to it. Consumers should only be able to use the functionality provided by it.  
If you can have only one of public or a privately accessible method, you no longer have to worry about the extension. This also allows you to change the underlying functionality of public API as much as you want, without breaking inheritable functionality of the class.  
And guess what? You can make it `final` without even thinking about it.

### Only abstract class can have protected members.
For most of the people I know out there, it is a subconscious decision to make every property protected. Why? I don't know. And I almost stopped caring, [until today](http://ocramius.github.io/extremely-defensive-php/#/66).  
Protected members are inherited by child classes and an abstract class completely justifies a protected member. If the class is abstract and it has a protected member it actively indicates that the member has a function which is not supposed to be available publicly but is a requirement for extension. Otherwise it is just another private member with a misleading access level.  
I recommend that you make it a habit to declare members `private`, and question yourself every time you declare a member with `protected` access level. If you think that the `protected` access is actually required it is most likely going to be the hidden piece of re-usable code.

### Putting it all together
It will probably make you want to kill me but if you maintain at least one open source project you'll know how important it is to clearly [define the behavioral specifications](http://ocramius.github.io/extremely-defensive-php/#/19) for your code.  
You can control every extension point in a project using five keywords and enforce the expectations. Stupid proof code will kick you in the butt every time you make a stupid decision. It will force you to think and wonder about stuff that you could've never had thought about.


### Links
1. Slides presented by Marco are available [here](http://ocramius.github.io/extremely-defensive-php)