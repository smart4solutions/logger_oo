# logger_oo
Object Orientated wrapper for logger

- [What is logger_oo?] (#what-is-logger_oo)
- [Prerequisites] (# Prerequisites)
- [How to install logger_oo?](# how-to-install-logger_oo)
- [How to use logger_oo](# how-to-use-logger_oo)
- License(# license)

# What is logger_oo?
Logger_oo is a wrapper for the logger utility from oraopensource (https://github.com/OraOpenSource/Logger).

# Prerequisites
The object is a wrapper for the logger package. You therefore need to have it installed in the current schema or you need to have a synonym in place so the object can find the logger package by referring to it as "logger".
If you installed logger using the installation instructions you should be safe.

# How to install logger_oo?
Install the object-definition by executeing the logger_oo.typ file.

You can install the object into the same schema as where you installed logger. In that case you might want to create a public synonym and grant execute on the object.
If PLSQL-OO is still new to you: think of a type as a package with data-attributes. But foremost as a package.

# How to use logger_oo?

On my blog (https://smart4solutions.nl/blog/logger-oo/) I try to explain why the tools was written and what I want to achieve with it.

within the declaration section of your program initialise the object by giving it a name and a so called "scope"

```
  lggr logger_oo := new logger_oo(p_scope => 'the_name_of_the_scope');
```
After that you can start using it:
```
begin

  lggr.add_param(p_name => 'p_paramname', p_value => p_paramname0);
  lggr.log_start;

  lggr.log('some text to log');
  lggr.log(p_text => 'some text', p_extra => 'some large_text');

exception
  when others then
    lggr.log_error(sqlerrm);
    raise;

end;
```
You surely will get the picture.. Use is pretty much the same is using logger, just easier.. :smirk:

# I want to make changes to your code
Feel free to do so. If you would like the code to be incorporated, then please send me a "pull-request".

# License

The MIT License (MIT)

Copyright (c) 2022 Smart4solutions B.V.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
