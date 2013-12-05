require 'test/unit'
require_relative '../src/job'

class TestJob < Test::Unit::TestCase

  def test_constructor
    title = 'title'
    url = 'url'
    date_posted = 'Jan  1'
    listing_site = 'Craigslist'
    unit = Job_Scraper::Job.new(title, url, date_posted, listing_site)
    assert_equal(title, unit.title, 'Failed to set the title')
    assert_equal(url, unit.url, 'Failed to set the URL')
    assert_equal(date_posted, unit.date_posted, "Failed to set 'date posted'")
    assert_equal(listing_site, unit.listing_site, 'Failed to set the listing site')
  end

  def test_accessors
    title = 'init_title'
    url = 'init_url'
    date_posted = 'init_date'
    listing_site = 'init_site'
    unit = Job_Scraper::Job.new(title, url, date_posted, listing_site)
    title = 'alt_title'
    url = 'alt_url'
    date_posted = 'alt_date'
    listing_site = 'alt_site'
    unit.title = title
    unit.url = url
    unit.date_posted = date_posted
    unit.listing_site = listing_site
    assert_equal(title, unit.title, 'Failed to update the title')
    assert_equal(url, unit.url, 'Failed to update the URL')
    assert_equal(date_posted, unit.date_posted, "Failed to update 'date posted'")
    assert_equal(listing_site, unit.listing_site, 'Failed to update the listing site')
  end

  def test_to_string
    title = 'title'
    url = 'url'
    date_posted = 'Jan  1 2013'
    listing_site = 'Craigslist'
    unit = Job_Scraper::Job.new(title, url, date_posted, listing_site)
    assert_equal("#{title} @ #{url} posted on #{date_posted} on #{listing_site}", unit.to_s)
  end
end
