---

layout: post_simple
title: Laravel Illuminate Support Package Introduction
permalink: post/laravel-illuminate-support-package-introduction
excerpt: "Laravel's __Support__ package offers a lot of cool stuff to use in any project, let check them out one at a time.  
I'll start with my favourite feature that I really like much more than anything else, and that is the helper functions provided by `illuminate\\support`.
"

date: 2014-04-24

tags: 
  - "Laravel"
  - "Module"
  - "Tips"

---

Laravel's __Support__ package offers a lot of cool stuff to use in any project, let check them out one at a time.  
I'll start with my favourite feature that I really like much more than anything else, and that is the helper functions provided by `illuminate\support`.

### Helpers
There are so many helper functions included in support package and I can't convince you more so as to why you should use them.

A plethora of array helper functions included in package will make your life so damn easy when it comes to working with arrays. Best thing about those functions is that they offers you a great way to operate on arrays using dot notations, this feels so natural, and in harmony with object oriented codes, that you can just not resist yourself.  
Naturally, `$name = array_get($user, 'name.first')` is much elegant solution than `$name = $user['name']['first']` and there are many other functions like this, including:

```php
array_add($user, 'name.last', 'Gufran');
array_pluck($users, 'name.first');
array_sort($user, $callback);
```

and many others.  
Those functions are specially useful to dynamically access the elements from deep inside an array. Imagine writing yourself 

```php
$secondaryCompany = $records[$recordId][$userId][$companyId]['name'];
```

and once you recover from the nightmare, also imagine writing 

```php
$keyString = $recordId . $userId . $companyId;
$secondaryCompany = array_get($records, $keyString);
```

Pretty nifty, heh!

You can find a full list and proper documentations for those functions on [official Laravel documentation page](http://laravel.com/docs/helpers#arrays)

Other functions provided by support package are string helpers. Here is an example of some of them but you should definitely check out the full documentation.

```php
str_contains('Hello World', 'World');
str_is('Hello', 'Hello');
snake_case('MainClassName');
studly_case('converts_from_snake_case');
camel_case('converts_from_snake_or_studly_case');
```

You can find complete documentation about those helper functions on [official Laravel documentation page](http://laravel.com/docs/helpers#strings)

Second in my favourites list is __Fluent__ class. 
### Fluent
This is not the _Fluent Query Builder_ class, this is something much more exciting than query builder.  
If you have been programming in any language for long enough you might have already discovered by now that arrays (and similar types) are one of the most used features in your codes. How about making those traditional PHP arrays a little more interesting to work with ?  
Well, Fluent class does just that. This class implements `ArrayAccess` interface which allows you to use the object of `Fluent` class as an array itself. What's more ? You now have simple _getter_ and _setter_ methods available to manipulate the array. Take a look at this:

```php
$userRecord = array(
    'first_name' => 'Mohammad',
    'last_name' => 'Gufran'
);
$record = new Fluent($userRecord);

$record->address('hometown, street, house');
echo $record->address;
```

as well as 

```php
$record['address'] = 'hometown, street, house';
echo $record['first_name'];
```

So, that is just PHP arrays with lipstick. This is not the most revolutionary invention ever but yeah, it does make your codes look much more object oriented.

Next in the line is Collection class.

### Collection
Think of collections as an upgrade to `Fluent` class. If you didn't noticed yet the `Fluent` class is limited in many ways, It can operate 'Fluently' on single dimensional arrays only. `Collection` class removes all those limitations, so basically _Collection is PHP arrays on steroids_.

Lets get this straight, Collection is Object Oriented PHP Arrays. It doesn't bring anything new to the table except the Object Oriented Interface to work with ugly looking PHP arrays. You know PHP faces all kind of criticism for it's inconsistent functions and features, take array functions for example, if you want to filter an array you have function `array_filter` at your disposal. Syntax for `array_filter` is

```php
array_filter($array, $callback);
```

which is all good for as long as you don't stumble across `array_map` function. Syntax for `array_map` is 

```php
array_map($callback, $array);
```

which is sort of inconsistent. There is a reason to why the argument list is inverted in `array_map` functions, it can take more than one array like `array_map($callback, $array1, $array2, $array3)` and apply callback on each of them. And if you supply the array at first and callback at second place then you would not be able to pass more than one array to it. This is one sensible reason but this is inconsistent nonetheless.  
Collection class make all array functions available as a method on Collection object - _in a consistent manner._

Take this for example

```php
$collection = new Collection($records);

$collection->implode(',');
$collection->first();
$collection->last();
$collection->lists('first_name'); // gives you an array of all first names
$collection->map($callback);
$collection->filter($callback);
// ... and a lot more methods
```

Oh, and of course you are free to use the object as array since it implements `ArrayAccess`, `ArrayIterator` and `IteratorAggregate` interfaces. So you can do pretty much anything that can be done with a traditional PHP array. things like

```php
foreach($collection as $element)
{
    //... get cozy here
}

$collection['name'] = 'Gufran';
echo $collection['status'];
```

Laravel documentations does not cover Collection class but this is something you can (and should) explore yourself, just open up the `Illuminate\Support\Collection` class in your IDE.  
Also, Jeffrey has covered the Collection class in this [Laracast here](https://laracasts.com/lessons/arrays-on-steroids). I highly recommend that you go ahead and watch it.

Moving on, the next part is the ClassLoader class
### ClassLoader

The `ClassLoader` class is a simple utility you want to have right besides _composer autoloader_. There are situations when composer autoloading is an overkill or you simply don't want to leverage composer autoloading due to packaging problems, in such a case you can register the `ClassLoader` class to load classes from directories you specify.  
You can register the class to manage autoloading by `ClassLoader::register()` method. At the top your index file, right after including the `vendor/autoload.php` file, call the method `ClassLoader::register()` like this

```php
include 'vendor/autoload.php';
\Illuminate\Support\ClassLoader::register();
```

After that you can add the directories you wish to autoload the classes from. So if I have directories `Controllers`, `Models`, and `Libraries` in my app directory I'd add them like this:

```php
$dirPaths = array(
    $controllersDir,
    $modelsDir,
    $librariesDir
);

\Illuminate\Support\ClassLoader::addDirectories()
```

And this is pretty much all to the `ClassLoader` class. You can now place all class file into respective directories and have them autoloaded without worrying about `composer`. ClassLoader class expects __PSR-4__ namespacing scheme so make sure the directory structure matches the namespace.

## Wrapping up
Finally, there are 2 more classes I wish to highlight, and those are `Pluralizer` and `Str`.  
Pluralizer class is pretty simple. It provides methods `Pluralizer::plural()` and `Pluralizer::singular()` which converts between singular and plural forms of a word.

`Str` class is a relatively big and provides a lot of methods to operate on strings. You can do things like converting between cases, comparing strings, finding substrings and a lot more. Here is an example:

```php
Str::is('Hello', 'Hello');         // Compare strings
Str::is('/there/i', 'There');      // Compare against a regex
Str::startsWith('Hello world', 'Hell');
Str::endsWith('Hello world', 'rld');
Str::contains('Hello world', 'lo wo');
Str::length('this string is 33 characters long');
Str::limit($longString, 100);     // Limit to 100 characters
Str::words($longString, 20);      // Limit to 20 words
```

This is not everything to `Str` class, if you wish to find out more about methods available to `Str` then make sure you go through the codes yourself, the file is located at `\Illuminate\Support\ClassLoader`.

Have fun browsing through codes until the next blog post, which, hopefully, will be much more interesting and advanced.