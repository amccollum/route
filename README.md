routes
======

Basic location hash routing Ender:

    function foo(year, month, day, id) {
        // ...
    };

    function bar(first, middle, last) {
        // ...
    };

    $.routes.add({
        'foo/:year/:month/:day/:id': foo,  // Regular arguments capture a single path part
        'bar/:first/*middle/:middle': bar  // Splat arguments capture any number of path parts
    });


Usage with Ender
----------------
After you install [Ender](http://ender.no.de), include `routes` in your package:

    ender add routes
