require 'rubygems'
require 'nokogiri'
require 'open-uri'

puts "Team,Results"
[ "Boston Celtics",
  "Brooklyn Nets",
  "New York Knicks",
  "Philadelphia 76ers",
  "Toronto Raptors",
  "Golden State Warriors",
  "Los Angeles Clippers",
  "Los Angeles Lakers",
  "Phoenix Suns",
  "Sacramento Kings",
  "Chicago Bulls",
  "Cleveland Cavaliers",
  "Detroit Pistons",
  "Indiana Pacers",
  "Milwaukee Bucks",
  "Dallas Mavericks",
  "Houston Rockets",
  "Memphis Grizzlies",
  "New Orleans Pelicans",
  "San Antonio Spurs",
  "Atlanta Hawks",
  "Charlotte Bobcats",
  "Miami Heat",
  "Orlando Magic",
  "Washington Wizards",
  "Denver Nuggets",
  "Minnesota Timberwolves",
  "Oklahoma City Thunder",
  "Portland Trail Blazers",
  "Utah Jazz"].each do |team|
    team_url = team.gsub(' ', '%20')
    url = "http://nl.newsbank.com/nl-search/we/Archives?p_product=AT&p_theme=at&p_action=search&p_maxdocs=200&p_field_label-0=Author&p_field_label-1=title&p_bool_label-1=AND&s_dispstring=#{team_url}%20AND%20date(01/01/1993%20to%2001/01/1994)&p_field_date-0=YMD_date&p_params_date-0=date:B,E&p_text_date-0=01/01/1993%20to%2001/01/1994)&p_field_advanced-0=&p_text_advanced-0=(#{team_url})&p_perpage=10&p_sort=_rank_:D&xcal_ranksort=4&xcal_useweights=yes"
    page = Nokogiri::HTML(open(url))
    text = page.at('p:contains("Need to narrow your results?")').text
    num = text.match(/Returned: (\d*) results of (\d*) matches/i).to_a[2]
    puts "#{team},#{num}"
end