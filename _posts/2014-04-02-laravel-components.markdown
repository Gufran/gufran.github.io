---

layout: post_simple
title: Laravel Components
permalink: post/laravel-components
excerpt: "It happens quite a lot of time with me that I have to sort out some legacy codes. Every time I am assigned the task I get told that these _'codes works, just improve them'_.  
I don't mind the language of a stupid creature who knows nothing about programming, I can't expect them to phrase - _'This is the logic we want. We somehow managed to stuff all of it into a shitload of crap one could possibly create with PHP, just sort it out if you want money'_ - correctly.
"

date: 2014-04-02

tags: 
  - "IoC Component"
  - "Laravel"
  - "Module"

---

It happens quite a lot of time with me that I have to sort out some legacy codes. Every time I am assigned the task I get told that these _'codes works, just improve them'_.  
I don't mind the language of a stupid creature who knows nothing about programming, I can't expect them to phrase - _'This is the logic we want. We somehow managed to stuff all of it into a shitload of crap one could possibly create with PHP, just sort it out if you want money'_ - correctly.

Anyways, to the hell with their working codes. First thing that I do with these codes is I pull in my toolbox. I pull in some Laravel, and you guess it - I get _paid_.

This is no big secret anymore that you can pull in whichever part of Laravel you want into your project, leaving those off your project does not require. But many people either does not know the fact or despite of knowing it they prefer to pull in the entire codebase making their application 99% Laravel and 1% _their Application._ Not anymore. Let's quickly run down through few simple steps to leverage the _IoC container_ and some magic dust offered by Laravel.

__If you are returning here for something you forgot to take note of or you don't have time to read through all of it, there is a TL;DR version [here](#tldr)__

We will start with an empty project so create a directory in your workspace and name it whatever the word is stuck in your mind for past few weeks! Yeah, doesn't really matter. I'll call mine __Illuminated.__

Fire up the terminal and initialise composer:

```sh
composer init
```
 
and leave off the dependencies part for now, we'll add them in manually.

At this point we have some rotten codes which apparently works and a `composer.json` file in our project directory. Now is the time to pull in the components.  
If you perform a thorough search for `Illuminate` on [packagist][packagist] website you'll see a lot of packages, all of them which starts with `Illuminate/***` are Laravel components that you can _just use._ Yeah really, it does however require a little bit of configuration but it is mostly trivial stuff. Lets search for `Illuminate/Container` and `Illuminate/Support` packages.

`Illuminate/Container` package is that so called _IoC_ container of Laravel where most of the sorcery takes place, and `Illuminate/Support` is the component which provides us with `Fluent` arrays, `Collection` array, `Str` class and all of these `array` and `string` helper functions you are used to (or maybe not! welcome to Laravel).

Update the `composer.json` file and add these dependencies in `required` section:

```
    "illuminate/support": "4.2.*@dev",
    "illuminate/container": "4.2.*@dev"
```

Notice that I'm using the bleeding edge release from `development` branch just to check out some new features, you might want to change that to __4.1.*__ if you need stable version. Run `composer install` to pull them in.  
Now that you are done with a mug of coffee and discussing the politics and business with people around you, composer should hopefully be finished installing the dependencies. We can now use them in our project.

Time to create an `index.php` file in your project root. You may want to create a few more directories like `Controllers`, `Models` etc. all of which we can register in Laravel's autoloader.  
In `index.php` file require the autoloader provided by composer (`'vendor/autoload.php'`) at top. And while we are at it let's also require the `helpers.php` file provided by `Support` package. This file should be located at `vendor/illuminate/support/illuminate/support/helpers.php` (Yes, you read that right). Our index file at this time should look like this:

```php
require './vendor/autoload.php';
require './vendor/illuminate/support/illuminate/support/helpers.php';
```

After that we need to register the class autoloader provided by Laravel.  
Laravel's class autoloader is provided by `Illuminate/Support` package and class resides at `Illuminate/Support/ClassLoader`. Take a look through the codes if you want to (I'd highly recommend that you do) and then we move on.  
To register the autoloader all it takes is a simple static call to `register()` method:

```php
require './vendor/autoload.php';
require './vendor/illuminate/support/illuminate/support/helpers.php';

Illuminate\Support\ClassLoader::register();
```

It would be a good idea to define some path variables now so that we can use them throughout the script, I'd define just the `$basePath` variable which points to the root of the project, we can use it to build other path as required.

```php
// use the str_finish helper method to assure a trailing slash at the end of path string

$basePath = str_finish(dirname(__FILE__), '/');

// if you have other directories define the path to them too
$libraries = $basePath . 'Libraries';
$services = $basePath . 'Services';
```

and now you can register these directories into the autoloader with the help of `addDirectories()` method:

```php
Illuminate\Support\ClassLoader::addDirectories(array($libraries, $services));
```

So far so good.  
We are ready to instantiate the container, let do that now. We will create an `$app` object of `Container` class:

```php
$app = new Illuminate\Container\Container();
$app->bind('app', $app);

// also bind the base path for some helper methods to use
// Overcome the mental block, you can bind literally anything into the container

$app->bind('path.base', $basePath);
```

Pretty good. We now have an instance of Container ready to serve the magic - but - what about that `$app->bind('app', $app)` part ? Nothing fancy, we are register the application instance into IoC container.

We need to also register the application instance into Facade class to get out `app()` helper function running:

```php
// Yes, that is an abstract class but you can still access 
// static methods
Illuminate\Support\Facades\Facade::setFacadeApplication($app);
```

Now we can use `app()` method to retrieve the instance of application or `app('foo')` to resolve the `foo` binding.

After this point things should be so predictable for anyone who is using Laravel for long enough to know about `App::bind()` and `App::make()` methods. If you are not one of them, well, shame on you, go read the [documentations][ioc-container] dammit.

### <a name="tldr"></a>TL;DR
Here is what we did so far. Add dependencies in your `composer.json` file

```
    "illuminate/support": "4.2.*@dev",
    "illuminate/container": "4.2.*@dev"
```

In `index.php` file register the autoloaders and instantiate the container. Also register project directories into the autoloader.

```php
require './vendor/autoload.php';
require './vendor/illuminate/support/illuminate/support/helpers.php';

// Register laravel's autoloader
Illuminate\Support\ClassLoader::register();

// use the str_finish helper method to assure a trailing slash at the end of path string
$basePath = str_finish(dirname(__FILE__), '/');

// if you have other directories define the path to them too
$libraries = $basePath . 'Libraries';
$services = $basePath . 'Services';

// register directories into autoloader
Illuminate\Support\ClassLoader::addDirectories(array($libraries, $services));

// instantiate the container
$app = new Illuminate\Container\Container();
$app->bind('app', $app);

// also bind the base path for some helper methods to use
// Overcome the mental block, you can bind literally anything into the container
$app->bind('path.base', $basePath);
$app->bind('path.libraries', $libraries);
$app->bind('path.services', $services);

// set application instance on Facade class so the helper methods
// can know about current instance of application
Illuminate\Support\Facades\Facade::setFacadeApplication($app);

// ------------------- Away you go ------------------- //
// Just make sure you namespace the classes properly and 
// according to the directory structure so that the ClassLoader
// can find and load them
```


[packagist]: http://packagist.org
[ioc-container]: http://laravel.com/docs/ioc