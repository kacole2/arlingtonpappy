# ArlingtonPappy
-------------

This rails app that will scrape the Arlington Wine liquor website for any results with the keyword 'Winkle'. It will notify you via SMS if that word is found. It will also scrape for the current inventory. With the use of Watir, the order process is automated to complete checkout.

Things you need to know:

* 2 Components:
  - Web Front End and Item is dictated by the first id: 1. This ID is created when the database is seeded.
  - A task worker by 'clockwork' does a reoccuring scrape. The time can be customized in lib/clock.rb.

* The current code base is deployed on Cloud Foundry. If you want to deploy on Heroku, it will require the use of a Procfile and using the same command that is in the manifest.yml file for 'clockwork'. In addition, this also requires multiple buildpacks. Watir uses phantomjs as a headless browser. Use this post [Heroku, Ruby on Rails and PhantomJS](https://github.com/edelpero/watir-examples/blob/master/watir_on_heroku.md) to deploy. No changes to PATH or LD_LIBRARY_PATH are required for Cloud Foundry.

* This requires two containers or two dynos if running on Cloud Foundry or Heroku, respectively. Watch out for $.

* Use the seed.rb file to seed the database for the first time.

* If deploying to Heroku, create environment variables where necessary. If deploying to Cloud Foundry, utilize the [Figaro Gem](https://github.com/laserlemon/figaro) to host all your environment variables.

More information can be found on [Creating a worker process on kendrickcoleman.com](http://kendrickcoleman.com/index.php/Tech-Blog/creating-a-worker-process-on-cloud-foundry-with-clockwork.html)

------------
## How To Push to Cloud Foundry:
	
* Setup the database:
  - `cf create-service elephantsql turtle kcoleman-arlingtonpappy-elephantsql`

* Deploy the application with the Web server and cron job using the manifest file that will seed the DB. all subsequent `cf push` will require editing the manifest to remove the db:create db:migrate and db:seed commands:
  - `cf push`