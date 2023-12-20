# sports-deal-emailer
i want to know when i can take advantage or sports discounts for local teams winning in my area.

## Installation

TODO: Write installation instructions here
:shrug:

## Usage

TODO: Write usage instructions here
:shrug:

## Development

TODO: Write development instructions here
when you wanna get insides of the db, execute the following future me:
```
sudo --login --user=postgres
psql -h localhost -p 5432 -U postgres -d sports_deal_emailer_dev
```
if you wanna get up and running on linux WITH the experimental `debugger`, you're gonna need to clone and compile your own version of crystal using the interpreter flag at compile time like: `make interpreter=1`. make sure that you've installed ALL of the dependencies listed in https://crystal-lang.org/install/from_sources/
post installation and verifying that your compiled crystal executable works (in install from sources section listed above), you should add the executable as an alias to make executing crystal easier with something like: `alias crystal='/absolute/path/to/crystal/bin/crystal'`. alias it since just executing `crystal` as you'd expect doesn't point to your compiled version of crystal. once the debugger is merged into main for all platforms this step should be unecessary

## Contributing

1. Fork it (<https://github.com/your-github-user/sports-deal-emailer/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Kalmai](https://github.com/your-github-user) - creator and maintainer
