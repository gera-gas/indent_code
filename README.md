# IndentCode

This utilities with CLI (Command Line Interface) for normalize indentation in your source code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'indent_code'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install indent_code

## Usage

For details use option `-h` or `--help`.

File for normalize 'test.c':
```
 #include <stdlib.h>

///Test function - 1. }
 void test1 ( void )
{
  switch(c) {
    case 4:
      c = "** \" { \" ";
      break;
    }
    
    if (c) 
      {
	return 1;
      }
}

/**
 * Test function - 2. {
 */
void test2 ( void )
{
  int a;
  /*
* Simple comment block.
        * Check align into comments.
	*/
{
  a++;
}
return a;
}
```

Run `indent` gem:

    $ indent test.c

and get follow result after normalize:
```
#include <stdlib.h>

///Test function - 1. }
void test1 ( void )
{
    switch(c) {
        case 4:
        c = "** \" { \" ";
        break;
    }
    
    if (c)
    {
        return 1;
    }
}

/**
 * Test function - 2. {
 */
void test2 ( void )
{
    int a;
    /*
     * Simple comment block.
     * Check align into comments.
     */
    {
        a++;
    }
    return a;
}
```

Also you can set indent size `-i 4` (set TAB size = 4 chars) and clean source code, by used `-c` option.
Clean option deleted code blocks framed is a: `#if 0` ... `#endif`.

    $ indent test.c -c
```
#include <stdlib.h>

#if EDEF
//Some text - 1.
# if 0
Deleted text.
# endif
//Some text - 2.
#endif
```

We get follow result after clean:
```
#include <stdlib.h>

#if EDEF
//Some text - 1.
//Some text - 2.
#endif
```

## Patch

Details information for each patch.

##### 0.1.1
* Corrected describe information.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/indent_code. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

