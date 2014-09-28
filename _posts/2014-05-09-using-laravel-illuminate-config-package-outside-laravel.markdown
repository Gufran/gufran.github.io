---

layout: post_simple
title: Using Laravel Illuminate Config Package Outside Laravel
permalink: post/using-laravel-illuminate-config-package-outside-laravel
excerpt: "Moving on with _Illuminate_, next in the series is `illuminate/config` package.  
In this article we'll go through the __config__ package which Laravel use to parse all those configuration files you see in `app/config` directory.
"

date: 2014-05-09

tags: 
  - "Laravel"
  - "Module"
  - "Tips"

---

Moving on with _Illuminate_, next in the series is `illuminate/config` package.  
In this article we'll go through the __config__ package which Laravel use to parse all those configuration files you see in `app/config` directory.


Lets start with an empty directory or [just skip to the TL;DR version](#tldr). I start with running `composer init` and then requiring the config package:

```sh
composer init
# snip...
composer require illuminate/config 4.1.*
```

This will bring in the Config package and all its dependencies for us. At this point you can also create a directory to hold our configuration files, I create a directory `config` in project root and also created a file named `app.php` in it. This is the content of my `config/app.php` file. 

```php
return array(
    'name' => 'Gufran',
    'type' => 'Geek',
    'job' => 'Messing up with computers'
);
```

Now, as always, you need to create an index file and require the `vendor/autoload.php` and `vendor/illuminate/support/Illuminate/Support/helpers.php` file.

```php
require 'vendor/autoload.php';
require 'vendor/illuminate/support/Illuminate/Support/helpers.php';
```

then you need to set up some path variables, including the path to configuration directory

```php
$basePath = str_finish(dirname(__FILE__), '/');
$configPath = $basePath . 'config';
```

Now, before moving on a quick lecture about `Config` facade you regularly use in a typical Laravel installation.  
`Config` facade maps to `Illuminate\Config\Repository` class which is responsible to fetch and resolve all configuration arrays, you can also include sub-directories in `config` directory which will be preferred based on application environment.

In order to initialise the config repository we first need to initialise the `Illuminate\Config\FileLoader` class which expects an instance of `Illuminate\Filesystem` and path to configuration directory:

```php
$filesystem = new Illuminate\Filesystem\Filesystem;
$loader = new Illuminate\Config\FileLoader($filesystem, $configPath);
```

Now we can create a config repository with this `FileLoader` instance. `Illuminate\Config\Repository` expects an instance of `FileLoader` and current application environment as a second constructor argument. This second argument - the environment - determines the configuration file to load. Default environment should be __production__ which means you wish to load default configuration, however, if you wish to load configuration for a different environment then make sure you have respective files in place under `config/<environment>/` directory. We initialise the repository...

```php
$config = new Illuminate\Config\Repository($loader, 'production');
```

... and we are done.

Now you can use `$config` variable to access configuration data as usual.

```php
$name = $config->get('app.name'); // Gufran
$type = $config->get('app.type'); // Geek
```

### <a name="tldr"></a>Finally, here is the TL;DR version

```php
require 'vendor/autoload.php';
require 'vendor/illuminate/support/Illuminate/Support/helpers.php';

$basePath = str_finish(dirname(__FILE__), '/');
$configPath = $basePath . 'config';

$loader = new Illuminate\Config\FileLoader(new Illuminate\Filesystem\Filesystem, $configPath);
$config = new Illuminate\Config\Repository($loader, 'production');

echo $config->get('app.name');
```

I hope you'll find good use of config package outside laravel, let me know what do you think about it in comments below.