# Description
This API based application that takes in a URL from LendingTree which returns all business reviews

# How to use
1) navigate to the root project directory and run:
  `bundle install` and then `rails s`

2) When the application is running, you can now access the `POST /reviews` endpoint which
   takes in a param value called `url`. Example of the URL is: `https://www.lendingtree.com/reviews/business/fundbox-inc/111943337`

# Future Work
- Add DB to store the reviews for each business, the design will be something like:
  Account -> has_many businesses -> has_many reviews
- web scraping through many different pages is very processing heavy so we could move the web scraping logic into its own API and run some kind of background processing like sidekiq
- Add caching

# Notes
Since we're webscraping through potenially tens of page, the runtime can vary based on the amount of review pages there are. Using the example link above which has 29 reviews, each review page contains 10 reviews so we have to web scrap 2 pages which can take 2-4 seconds. On URL with more reviews, the runtime can be take longer.