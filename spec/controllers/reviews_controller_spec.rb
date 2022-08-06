require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  subject(:review_controller) { described_class.new }

  describe 'POST reviews' do
    context 'valid LendingTree review Url' do
      context 'when a page has reviews' do
        before(:each) do
          allow(OpenURI).to receive(:open_uri).and_return(File.new("#{Rails.root}/spec/fixtures/review_page_mock.html"))
        end
        it 'returns 10 reviews' do
          post :reviews, params: { url: 'https://www.lendingtree.com/reviews/business/asdfjkaklsdfj' }
          response_body = JSON(response.body)
          expect(response.status).to eq(200)
          expect(response_body['number_of_reviews']).to eq(10)
        end
      end
      context 'when a page has no reviews' do
        before(:each) do
          allow(OpenURI).to receive(:open_uri).and_return(File.new("#{Rails.root}/spec/fixtures/no_review_page_mock.html"))
        end
        it 'returns 0 reviews' do
          post :reviews, params: { url: 'https://www.lendingtree.com/reviews/business/asdfjkaklsdfj' }
          response_body = JSON(response.body)
          expect(response.status).to eq(200)
          expect(response_body['number_of_reviews']).to eq(0)
        end
      end
    end
    context 'Invalid LendingTree Url' do
      it 'throw 403 when url is not a LendingTree Url' do
        post :reviews, params: { url: 'www.lendingtree' }
        error_message = JSON.parse(response.body)
        expect(response.status).to be(403)
        expect(error_message['message']).to eq(NotValidLendingTreeUrl::MESSAGE)
      end
    end
    context 'invalid review url' do
      it 'throw 403 when url is not a review Url' do
        post :reviews, params: { url: 'https://www.lendingtree.com/reviews/business/asdfjkaklsdfj' }
        error_message = JSON.parse(response.body)
        expect(response.status).to be(403)
        expect(error_message['message']).to eq(NotValidReviewUrl::MESSAGE)
      end
    end
  end
end
