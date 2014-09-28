---

layout: post_simple
title: Handle Form Data And Validation
permalink: post/handle-form-data-and-validation
excerpt: "A frequently asked question among developers is _'Where should I put validation logic ?'_, and My not so popular answer to the question is _'Put it in the form.'_  
And without getting into any debate about it let me introduce you to my [new package _Former_](https://github.com/Gufran/former), which I extracted out of a project I am working on.
"

date: 2014-08-02

tags: 
  - "Concept"
  - "Laravel"
  - "Package"
  - "Tips"

---

A frequently asked question among developers is _"Where should I put validation logic ?"_, and My not so popular answer to the question is _"Put it in the form."_  
And without getting into any debate about it let me introduce you to my [new package _Former_](https://github.com/Gufran/former), which I extracted out of a project I am working on.



Before you can do anything with it you need to install the package in your project. If you haven't already then go ahead and run `composer require gufran/former *`.  

Now, all you need to do is to create a class which represents a form and set validation rules on it. This class will extend `Gufran\Former\GenericForm` and should implement an abstract method `getRules()` which will return an array of rules. Here is an example for a `SignupForm`.

```php
<?php namespace Acme\Forms;

use Gufran\Former\GenericForm;

class SignupForm extends GenericForm {
    protected function getRules()
    {
        return array(
            'first_name' => 'required',
            'last_name' => 'required',
            'email' => 'required|email',
            'password' => 'required|min:8|max:32|confirmed'
        );
    }
}
```

Now you are ready to inject this form into any class. In a controller for example:

```php
<?php use Acme\Forms\SignupForm;

class AccountController extends BaseController {

    private $form;

    /**
     * Let Laravel inject the SignupForm into controller
     */
    public function __construct(SignupForm $form)
    {
        $this->form = $form;
    }
    
    public function store()
    {
        // check if form is valid
        if($this->form->isValid())
        {
            // save the form into database
            User::create($this->form->getValues());
            return Redirect::route('confirm_signup');
        }
        else
        {
            // If form is not valid then get all error messages and notify user
            return Redirect::back()->withErrors($this->form->messages());
        }
    }
}
```

And that is it.  
Yeah, really! The form retrieve the data from `Request` and run a validation against rules defined in `getRules` method. You don't need to worry about the values because only the values for elements defined in rules will be fetched, in this case `first_name`, `last_name`, `email`, `password`. And if there is any confirmation field like `password_confirmation` it will fetch that too. `getValues()` method will filter the confirmation fields so you don't need to worry about saving the data directly to model as well.

There are several methods available to a `GenericForm` object:

 - `validates()`: This is the function which determines whether or not the form is valid.
 - `isValid()`: This is an alias for `validates()`, use whichever makes more sense.
 - `isInvalid()`: As the name suggests, this will check if the form is invalid.
 - `getValues()`: Get values from form as an array. Only those values which have a corresponding rule will be returned.
 - `get( string )`: Get a value by its name.

Furthermore, the `GenericForm` implements `IteratorAggregate` interface so you can also iterate over the object as if it was an array, take this for an example:

```php
<?php
// Iterate over the form to process each element
foreach($this->form as $element => $value)
{
    $safeInput[$element] = Crypt::encrypt($value);
}
```

`ArrayAccess` interface is also implemented by `GenericForm` that enables you to use the object like an array, for example:

```php
<?php
// Get the value of first_name and last_name
echo $this->form['first_name'];
echo $this->form['last_name'];
```

So that's it folks, I hope you can use this tiny little package in your projects. Leave your appreciation and comments below and if you find any problem then please open an issue over [Github repository](https://github.com/Gufran/former).