require 'open-uri'
require 'nokogiri'

# URL for Craigslist Tech Support Jobs
url = 'http://portland.craigslist.org/tch/'

# Collect page data with Nokogiri
page_data = Nokogiri::HTML(open(url))

# Build date string ([Abbreviate month] [Blank Padded Day])
yesterday = (Time.now - 86400).strftime('%b %e')

jobs = page_data.css('.row')

yesterdays_jobs = []
jobs.each do |job|
  yesterdays_jobs << job.at_css('.pl') if job.at_css('.date').text == yesterday
end

