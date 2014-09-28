---

layout: post_simple
title: Lets Take A Look At Laravel 5
permalink: post/lets-take-a-look-at-laravel-4-3
excerpt: "Laravel <del>4.3</del> 5 is still due official release but you can already check it out at Github and install using composer.
Let's check out what new in this shiny new release.
"

date: 2014-09-04

tags: 
  - "IoC Component"
  - "Laravel"
  - "Laravel 4.3"
  - "Module"
  - "Tips"
  - "Trick"

---

Laravel <del>4.3</del> 5 is still due official release but you can already check it out at Github and install using composer by running

```sh
composer create-project laravel/laravel Laravel5 dev-develop
```

Let's check out what new in this shiny new release.


### Contracts
I'll start with all those new contracts now built into separate package, with those contracts abstracted out of the foundation there is a lot of things you can do with them. For each laravel package there are now contracts available that you can implement and bind into IoC container to alter the functionality of the application - Just like that. No _'I wish this class could do that'_ thing anymore.  
Now for an example, there is exception handler contract `Illuminate\Contracts\Exception\Handler` which defines the way the exceptions will be handled by the application. I went ahead and wrote my own exception handler:

```php
namespace App\Library\Exception;

use Closure;
use Exception;
use Illuminate\Http\Response;
use Illuminate\Contracts\Exception\Handler as ExceptionHandlerContract;

class ExceptionHandler implements ExceptionHandlerContract
{
    protected $handlers = array();
    
    public function error(Closure $callback)
    {
        array_unshift($this->handlers, $callback);
    }
    
    public function pushError(Closere $callback)
    {
        $this->handlers[] = $callback;
    }
    
    public function handleException(Exception $exception)
    {
        return new Response('There was an error, But I ate it.', 500);
    }
}
```

The last thing you'd want from your application is to spit out a stack trace in production, This little Dog of exception handlers is perfect for those times. Let's register it now. Open up the `app/Providers/ErrorServiceProvider.php` file and inside `register()` method put this binding:

```php
$this->app->bind('Illuminate\Contracts\Exception\Handler', 'App\Library\Exception\ExceptionHandler');
```

Cool, now you can sleep better at night.

There are contracts for every core package and you can implement them as required by your application, so go ahead and feel free to mix and match.

### IoC Container
IoC container has received a touch-up too, and honestly, this is my favourite feature of all time.

You write classes all the time, they have dependencies and you let IoC container inject those dependencies into the object, then you create service providers to instantiate objects and that is all to it.  
But what a shame it is at times when you are injecting a dependency into constructor and this particular dependency is only used by a single method which itself is not used frequently! Isn't that a shame ? Arn't you guilt ? Say it out loud! Don't you feel that guilt creeping onto yourself when you lie there on your bed at night ? Say it louder!  
Yes, that is the feeling you get when you sin. But thankfully, not anymore.

IoC container now has the ability to inject dependencies into methods and closures. There are two new methods available at container namely `Wrap` and `Call`. Here is how you can use them.

Method `Call`, as the name suggests, can call a _callable_ while injecting proper dependencies into it. Consider this as an example:

```php
class Dependency
{
    public function getDescription()
    {
        return 'this is a dependency';
    }
}

class Operational
{
    public function runOperation(Dependency $dep)
    {
        return 'Description of dependency: ' . $dep->getDescription();
    }
}

$operational = new Operational();

echo App::call([$operational, 'runOperation']);
// Guess what ?
```

Wasn't that a little too easy ? What happened here is that the `runOperation` method was called on `$operational` object with an object of class `Dependency` injected into it. And tell you what? that is not all to it.  
You can also specify an array of arguments for dependency injection as a second argument to `call` method and those will be injected into the method as well. I know that sounds tricky but that is not, look at this for example:

```php
class Dependency
{
    public function getDescription()
    {
        return "This is same as above, isn't it ?";
    }
}

class Operational
{
    public function runOperation($name, $age, Dependency $dep, $occupation)
    {
        return 'Name: ' 
             . $name 
             . ', Age: ' 
             . $age 
             . ', Occupation: ' 
             . $occupation 
             . ' Desc: ' 
             . $dep->getDescription();
    }
}

$operational = new Operational();

echo App::call([$operational, 'runOperation'], [
               'name' => 'Gufran', 
               'age' => '23', 
               'occupation' => 'Drinking coffee'
]);
```

What you are expecting from these codes is correct (unless you think this will whank).  
So, a quick recap, The call method will call any `callable` while injecting proper dependencies into it, whats more is that you can specify the dependencies as second argument to call method and it will automatically determine which one goes in where. Doesn't matter the order of elements in array.

The `warp` method is similar to `call` but `wrap` takes a closure as first argument and an array of arguments as second argument, it will then then wrap the given closure such that it's dependencies will be injected when executed. Here is an example:

```php
$callEvent = function($name, Dependency $depOne, $age, Operational $depTwo)
{
    echo $name . $depOne->run() . $age . $depTwo->run();
}
```

This closure has `Dependency` class and `Operational` class as its dependency, we can call it directly using `App::call()` method and that will work just fine but we want to prepare the closure for execution and execute it at a later time, that is when you call `wrap`:

```php
$callableEvent = App::wrap($callEvent, ['name' => 'Gufran', 'age' => 23]);
```

Now you can pass around the `$callableEvent` to other methods and call it when you want, this will work as expected.


### Support Package
Last time when [I wrote about the support package](http://www.gufran.me/post/laravel-illuminate-support-package-introduction) all those cool little helpers functions were available in `helpers.php` file. They still are but how they function internally now is a little different.  
All the array helper functions are moved to a dedicated class `Illuminate\Support\Arr`, so now you can access `Arr::dot()`, `Arr::build()`, `Arr::divide()` etc. of `Arr` facade

So, This is all for now, people. More Laravel 4.3 related posts will appear here soon so keep an eye out for them.