require 'csv'

arrs = CSV.read("teamdata2.csv")

results = []
arrs.each do |item|
  arrs.each do |com|
    if item[2] == com[2]
      results << item
      break
    end
  end
end

CSV.open("teamresults.csv", "w") do |csv|
  csv << ["From","To","School","performance"]
  results.each do |r|
    csv << r
  end
end

