# sports-deal-emailer
backstory: my car hasn't been washed in years, instead of just checking my mobile device for the blue jackets score like a sane person. i wanted to create an application that would notify me when the blue jackets scored enough times to allow me to get the free car wash i truly need.

we can pull sports teams for region using this handy dandy api https://ballyrsnfeed.channelfinder.net/?zip=43026&dtc=t , when we haven't seen the zip code yet, we create a new entry on the table which will be collecting all this data so we don't have to spam this api. if the zip code exists on our team lookup table, we won't hit the api. it looks like this api only supports "MLB", "MLS", "NBA", "NHL", "WNBA" as per perhaps bally doesn't actually care about other sports since they don't broadcast them (bally does nhl productions in cmh area etc). a possible solution would be to have an account with ballysports and just update my zipcode with their account api and navigate to whatever url they use to display stuff since they don't seem to send request to their BE with params which i can take advantage of meaning i need to find and enter the zipcode we want to look up with their SPA which might not be the worst solution, just want to be able to scrap the data off of some site. it seems like there are already shards out there for scrapping data off the web since f*** sports companies for making this info such a pain to get. ~~https://github.com/madeindjs/Crystagiri this might be a good solution once we have an endpoint we can hit to scrape the data for not only the teams in the zipcode, but the promotions explored a little below~~ turns out there are better libs to scrape sites with such as https://github.com/Kanezoh/mechanize.cr only problem is that if you compile your own version of crystal, you cannot run the application. to remedy this, just point to your local non-compiled version of crystal and you can run the application jsut fine.
it looks like ballysports just doesn't serve up competitors info which makes sense, but still...
anyways, this site might be easier to scrape since it seems to be channel agnostic? https://www.directv.com/sports/regional-sports-locator/

it looks like each league has a page which lists all of the deals for a specific major league team 
this seems like a s***-show. all of the teams might manage their own website under some super site
which is leading to different endpoints for promotions. for the nhl for example we have https://www.nhl.com/bluejackets/fans/gameday-central#gameday-promotions and https://www.nhl.com/penguins/fans/contests 
football nfl: all of the nfl teams seem to be using the same site under the hood. it looks like the path to the individual team is something like https://www.clevelandbrowns.com/fans/contests
hockey nhl: similar situation to the nfl but the url is different https://www.nhl.com/penguins/fans/contests
basketball nba:
baseball mlb:
soccer mls:

## Installation

clone the repo, either install crystal for your respective platform, OR...
it looks like you need to have a released version for your platform to install shards. just have installs of crystal lang

if you wanna get up and running on linux WITH the experimental `debugger`, you're gonna need to clone and compile your own version of crystal using the interpreter flag at compile time like: `make interpreter=1`. make sure that you've installed ALL of the dependencies listed in https://crystal-lang.org/install/from_sources/

post installation and verifying that your compiled crystal executable works (in install from sources section listed above), you should add the executable as an alias to make executing crystal easier with something like: `alias crystal='/absolute/path/to/crystal/bin/crystal'`. alias it since just executing `crystal` as you'd expect doesn't point to your compiled version of crystal. once the debugger is merged into main for all platforms this step should be unecessary


you need to set up the database for local development. steps for creating the database will follow...

## Usage

TODO: Write usage instructions here
:shrug:

## Development
you need to build a .env file living at the root of the project that includes current this list of keys:
```
SEND_GRID_API_KEY=<issue-yourself-a-new-key>
ENVIRONMENT=development
PG_USER=postgres
PG_PASSWORD=postgres
PG_HOST=localhost
PG_PORT=5432
PG_DB_NAME=sports_deal_emailer_dev
```
when you wanna get insides of the db, execute the following future me:
```
sudo --login --user=postgres
psql -h localhost -p 5432 -U postgres -d sports_deal_emailer_dev
```
## Contributing

1. Fork it (<https://github.com/your-github-user/sports-deal-emailer/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Kalmai](https://github.com/your-github-user) - creator and maintainer
