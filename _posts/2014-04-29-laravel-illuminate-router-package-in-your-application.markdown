---

layout: post_simple
title: Laravel Illuminate Router Package In Your Application
permalink: post/laravel-illuminate-router-package-in-your-application
excerpt: "In my previous article I talked about consuming services from `Illuminate\\Support` package, Now its time to talk about `Illuminate\\Routing`.

Laravel's router works wonder, and so do every other component of it, but to keep things to the point lets not talk about other components right now (you know they'll all have their own articles).  
In this article I'm going to talk about how you can get Laravel's routing package up in your application to handle every damn piece of routing.
"

date: 2014-04-29

tags: 
  - "Laravel"
  - "Module"
  - "Tips"

---

In my previous article I talked about consuming services from `Illuminate\Support` package, Now its time to talk about `Illuminate\Routing`.

Laravel's router works wonder, and so do every other component of it, but to keep things to the point lets not talk about other components right now (you know they'll all have their own articles).  
In this article I'm going to talk about how you can get Laravel's routing package up in your application to handle every damn piece of routing.


Here is the [TL;DR](#tldr) version for impatient.

For everyone else, If you don't already know about it, the `routing` component is the one which provides the `Route` facade and lets you define routes and filters

```php
Route::get('/', function() {
    return 'Hey there, World! How are you doing ?';
});

Route::get('/hello', 'HelloController');
```

Lets see how can you possibly pack your application into one file, not counting the controllers and models of course.

We start by pulling in the `illuminate\routing` package via composer, so open up your terminal, initialise the composer by running

```sh
composer init
```

and run 

```sh
composer require illuminate\routing 4.1.*
```

Now, before proceeding, just require this one more package

```sh
composer require illuminate\events 4.1.*
```

This is a little off the track as `router` depends on `events` package but do not state it as a composer dependency. Since we know (by looking at `Illuminate\Routing\Router::__constructor`) that it requires an instance of `EventDispatcher`, we pull that in as well.

Moving on, its time to set every thing up. At this point I'd recommend you to read this article I posted some time ago titled _[Use Laravel's Goodies In Your Application](http://www.gufran.me/post/laravel-components)_ which is about setting up Laravel's IoC container outside Laravel, once done we move on.

You might want to create directories in your app root such as `Controllers` and `Models` which will contain your controllers and models respectively. I'll assume those directories are in place.

I also want you to create a `routes.php` file in your project root and put this in the file

```php
$app['router']->get('/', function() {
    // Because 'Hello, World!' is too mainstream
    return 'Are you looking for me ?';
});
```

And then I want you to forget about this `routes.php` until the very end of this article.

Now in your `index.php` file require the composer autoloader file and `illuminate\support\helper.php` too. Here is how I did it in my file

```php
require 'vendor/autoload.php';
require 'vendor/illuminate/support/Illuminate/Support/helpers.php';
```

Now register the laravel's autoloader and add those Controllers and Models directories with it to autoload our controllers and models. This is how it looks in my file:

```php
$basePath = str_finish(dirname(__FILE__), '/');
$controllersDirectory = $basePath . 'Controllers';
$modelsDirectory = $basePath . 'Models';

// register the autoloader and add directories
Illuminate\Support\ClassLoader::register();
Illuminate\Support\ClassLoader::addDirectories(array($controllersDirectory, $modelsDirectory));
```

Next up, we need to create an instance of IoC container to run our application off of it, Simply instantiate the container and register it as our application:

```php
// Instantiate the container
$app = new Illuminate\Container\Container();

// Tell facade about the application instance
Illuminate\Support\Facades\Facade::setFacadeApplication($app);

// register application instance with container
$app['app'] = $app;

// set environment 
$app['env'] = 'production';
```

Cool, now with those preambles out of the way we can finally set up the routing.  
A little bit of configuration is required before you can dispatch the router, thanks to Laravel's service providers you can just register the services with them. Go ahead and register the `EventServiceProvider` and `RoutingServiceProvider` like this:

```php
with(new Illuminate\Events\EventServiceProvider($app))->register();
with(new Illuminate\Routing\RoutingServiceProvider($app))->register();
```

If you remember, this `with()` function is actually provided by `Illuminate\Support\helpers.php` file which just returns whatever is given to it, so basically we are calling the `register()` method on instances of those service providers.  

Speaking of configuration, this is all it takes. Yes, Crazy. I know that.

Remember the `routes.php` file we create in very beginning ? its time to require that file now. Add this line in your index.php file

```php
require $basePath . 'routes.php';
```

and before you try to run the app here is the spoiler, It won't work. Not quite yet, we'll fix that.

We are now all set to dispatch the router, but before we can do that the router need to know about the request we want it to handle. This is where `Illuminate\Http\Request` come into play. You can instantiate the `Request` class with global variables and dispatch the router with it. On dispatch the router will return `Illuminate\Http\Response` which you can `send` back to the user. Here is how it is going to work:

```php
// Instantiate the request
$request = Illuminate\Http\Request::createFromGlobals();

// Dispatch the router
$response = $app['router']->dispatch($request);

// Send the response
$response->send();
```

Believe it or not (I highly recommend that you do :P) this is everything.

### <a name="tldr"></a>TL;DR
Here is the full and final `index.php` file as a TL;DR version

```php
require 'vendor/autoload.php';
require 'vendor/illuminate/support/Illuminate/Support/helpers.php';

$basePath = str_finish(dirname(__FILE__), '/');
$controllersDirectory = $basePath . 'Controllers';
$modelsDirectory = $basePath . 'Models';

Illuminate\Support\ClassLoader::register();
Illuminate\Support\ClassLoader::addDirectories(array($controllersDirectory, $modelsDirectory));

$app = new Illuminate\Container\Container;
Illuminate\Support\Facades\Facade::setFacadeApplication($app);

$app['app'] = $app;
$app['env'] = 'production';

with(new Illuminate\Events\EventServiceProvider($app))->register();
with(new Illuminate\Routing\RoutingServiceProvider($app))->register();

require $basePath . 'routes.php';

$request = Illuminate\Http\Request::createFromGlobals();
$response = $app['router']->dispatch($request);

$response->send();
```

Now visit the application and you should see __Are you looking for me ?__. (By the way I really love the PHP server to check out this type to quick scripts, Invoke it by running `php -S localhost:8888` in project root directory)

With `$app['router']` you can do everything that you normally do with `Route` facade in your Laravel application. You can route to controllers (your controllers will extend `Illuminate\Routing\Controller` instead of `BaseController`), create resources, create route filters, create routes group, bind models, match route to regex and whatnot.

This is all for this article, Until the next post just give it a spin and experiment with your own controllers and models.  
I hope you'll be able to find some good use of `illuminate\routing` in reviving a legacy codebase.