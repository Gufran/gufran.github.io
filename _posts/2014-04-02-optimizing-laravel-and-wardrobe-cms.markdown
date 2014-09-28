---

layout: post_simple
title: Optimizing Laravel And Wardrobe Cms
permalink: post/optimizing-laravel-and-wardrobe-cms
excerpt: "Its time to talk about those optimisations I mentioned in my [previous post](http://www.gufran.me/post/migration-from-wordpress-to-wardrobe-cms).
Laravel already packs a punch in `php artisan optimise` command but ever since I moved my blog to WardrobeCMS I couldn't wait to experiment with things. This is not a company project after all, this is _My Blog_ and I can break it a hundred gazillion times a day - No Questions.  
"

date: 2014-04-02

tags: 
  - "Laravel"
  - "Optimisation"

---

Its time to talk about those optimisations I mentioned in my [previous post](http://www.gufran.me/post/migration-from-wordpress-to-wardrobe-cms).
Laravel already packs a punch in `php artisan optimise` command but ever since I moved my blog to WardrobeCMS I couldn't wait to experiment with things. This is not a company project after all, this is _My Blog_ and I can break it a hundred gazillion times a day - No Questions.  


In my case I prepared a custom _minimal_ Laravel setup from scratch with all required dependency defined explicitly, It was out of curiosity and to check how far things can be stretched with Laravel. You'll probably not need that so let's not complicate things right now, I'll talk about that process in a later article.  

Ok, lets dive in. In my case I am running __WardrobeCMS__ from __dev-master__ branch and __Laravel__ version __4.1.*__, If you are below `4.0.1` then a couple things might not work for you or you may experience minor glitches here and there so before proceeding make sure we both are working on same thing.

### Remove The ServiceProviders
I started with service providers array in `app/config/app.php` file. Just open the file and take a look at `providers` array, you can clean up a lot of it.  
In your application you probably don't require the `Artisan` service (double check with your codebase), once you make sure you are not calling `Artisan` from inside your application just go ahead and comment out those service providers:

```
'Illuminate\Foundation\Providers\ArtisanServiceProvider',
'Illuminate\Session\CommandsServiceProvider',
'Illuminate\Foundation\Providers\ConsoleSupportServiceProvider',
'Illuminate\Database\MigrationServiceProvider',
'Illuminate\Remote\RemoteServiceProvider',
'Illuminate\Database\SeedServiceProvider',
'Illuminate\Workbench\WorkbenchServiceProvider',
```

This will disable a lot of `artisan` functionality, go ahead and run `php artisan` to check it out.  
Apart from those service providers I also removed

```
'Illuminate\Queue\QueueServiceProvider',
'Illuminate\Html\HtmlServiceProvider',
```

because I know I do not need them on my blog. You can safely remove them if you are running only WardrobeCMS.

### Add Them Back
Next, we will place those service providers back but only for `artisan` this time. That means all those service providers will only be invoked if and only if `artisan` is invoked.  
Open up the `app/start/artisan.php` file and create an array of those service providers, then register them with `App::register()`, like this:

```php
$providers = array(
    'Illuminate\Foundation\Providers\ArtisanServiceProvider',
    'Illuminate\Session\CommandsServiceProvider',
    'Illuminate\Foundation\Providers\ConsoleSupportServiceProvider',
    'Illuminate\Database\MigrationServiceProvider',
    'Illuminate\Remote\RemoteServiceProvider',
    'Illuminate\Database\SeedServiceProvider',
    'Illuminate\Workbench\WorkbenchServiceProvider',
);

foreach ($providers as $provider) {
    App::register($provider);
}
```

Now those service providers will only be registered with artisan console. This is already pretty big improvement if you ask me but there more.  

### Squeeze The App Into One File
Next up, lets register a couple of classes for optimised loading. Open up the file at `app/config/compile.php` and add wardrobe classes.  
Wardrobe is pretty small codebase, you can add almost everything in here to crunch and squeeze it into a single file but in my case I left out the controller class. Adding controller classes in here was generating a bizarre error message with no traceback so I still haven't figured out the exact reason for it, if you know how to fix that it please let me know in comments.  
I added these files in `app/config/compile.php`

```
__DIR__ . '/../../vendor/wardrobe/core/src/Wardrobe/Core/Repositories/DbPostRepository.php',
__DIR__ . '/../../vendor/wardrobe/core/src/Wardrobe/Core/Repositories/DbUserRepository.php',
__DIR__ . '/../../vendor/wardrobe/core/src/Wardrobe/Core/Repositories/PostRepositoryInterface.php',
__DIR__ . '/../../vendor/wardrobe/core/src/Wardrobe/Core/Repositories/UserRepositoryInterface.php',
__DIR__ . '/../../vendor/wardrobe/core/src/Wardrobe/Core/Models/BaseModel.php',
__DIR__ . '/../../vendor/wardrobe/core/src/Wardrobe/Core/Models/Post.php',
__DIR__ . '/../../vendor/wardrobe/core/src/Wardrobe/Core/Models/Tag.php',
__DIR__ . '/../../vendor/wardrobe/core/src/Wardrobe/Core/Models/User.php',
```

After saving the file you'll need to run

```sh
php artisan optimize --force
```

You may need that `--force` switch depending on `debug` element in `app/config/app.php` file,  if you have `debug` on then you need `--force` switch otherwise it is ok to leave it off.

This is basically all you need to pack all of WardrobeCMS into a single file and running laravel with minimum components loaded in memory.  
Wardrobe make use of caching heavily so you don't need to worry about things any further.

### And You're Done
Enjoy the speed. 
