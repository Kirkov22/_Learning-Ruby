require 'test/unit'
require_relative '../src/craigslist'
require_relative '../src/job'

class TestJob < Test::Unit::TestCase

  def test_scrape
    test_file = File.open('craig_test.html')
    year = Time.now.year
    jobs = Job_Scraper::Craigslist.scrape(test_file)
    test_job1 = Job_Scraper::Job.new('Job 1 Title', \
      "#{test_file}/job1.html", "Dec  1 #{year}", 'Craigslist')

    test_job2 = Job_Scraper::Job.new('Job 2 Title', \
      "#{test_file}/job2.html", "Dec  2 #{year}", 'Craigslist')

    test_job3 = Job_Scraper::Job.new('Job 3 Title', \
      "#{test_file}/job3.html", "Dec 31 #{year}", 'Craigslist')

    assert_equal(test_job1.to_s, jobs[0].to_s, 'Failed to detect job #1')
    assert_equal(test_job2.to_s, jobs[1].to_s, 'Failed to detect job #2')
    assert_equal(test_job3.to_s, jobs[2].to_s, 'Failed to detect job #3')
  end
end
