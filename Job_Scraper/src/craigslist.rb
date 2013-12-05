require 'nokogiri'
require 'open-uri'
require_relative 'job'

module Job_Scraper

  class Craigslist

    def self.scrape(url)
      page_data = Nokogiri::HTML(open(url))
      jobs = []

      page_data.css('.row .pl').each do |listing|
        title = listing.xpath('a').text.strip
        job_url = "#{url}/#{listing.xpath('a').attr('href').text}"
        date = "#{listing.at_css('.date').text} #{Time.now.year}"
        jobs << Job.new(title, job_url, date, 'Craigslist')
      end
      
      jobs
    end

  end
end
