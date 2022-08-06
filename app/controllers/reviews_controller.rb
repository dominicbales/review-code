class ReviewsController < ApplicationController
  require 'open-uri'
  require 'nokogiri'

  def index
    render json: { msg: 'This is a empty route, please use "POST /reviews" to fetch business reviews' }
  end

  def reviews
    formatted_url = format_url
    total_reviews = []
    page_number = 1
    loop do
      reviews = parse_reviews(formatted_url + page_number.to_s)
      break if reviews.length <= 0

      total_reviews.concat(reviews)
      page_number += 1
    end

    render json: { msg: total_reviews, number_of_reviews: total_reviews.length }
  end

  private

  def reviews_params
    params.require(:url)
  end

  def validate_url?(url)
    url[0..44] == 'https://www.lendingtree.com/reviews/business/'
  end

  def format_url
    url = reviews_params
    formatted_url = "#{url}?sort=&pid="
    raise NotValidLendingTreeUrl unless validate_url?(formatted_url)

    formatted_url
  end

  def parse_reviews(url)
    doc = nil
    begin
      doc = Nokogiri::HTML(OpenURI.open_uri(url))
    rescue StandardError
      raise NotValidReviewUrl
    end

    no_reviews = has_no_reviews?(doc)
    return [] if no_reviews == 'No Review Found'

    fetch_reviews(doc.css('.mainReviews'))
  end

  def fetch_reviews(reviews)
    total_reviews = []
    reviews.each do |review|
      item = {}
      item[:title] = review.css('.reviewTitle')&.text
      item[:content] = review.css('.reviewText')&.text
      item[:author] = review.css('.consumerName')&.text
      item[:date] = parse_review_date(review.css('.consumerReviewDate')&.text)
      item[:rating] = parse_ratings(review.css('.numRec')&.text)
      total_reviews.push(item)
    end
    total_reviews
  end

  def has_no_reviews?(doc)
    doc.xpath("//section[@class='lenderReviews']/div/div/label").text
  end

  def parse_ratings(ratings)
    formatted_rating = ratings.split('')
    formatted_rating[1]
  end

  def parse_review_date(date)
    formatted_date = date.split(' ')
    formatted_date[2, date.length].join(' ')
  end
end
