require "csv"
require "json"
require "open-uri"

results = Hash.new(0)
CSV.open("gendercsv.csv", "wb") do |csv|
  CSV.foreach("genderdata.csv") do |item|
    if item[0]
      name = item[0]
      name = name.gsub(" ", '%20')
      data = open("http://api.genderize.io?name=#{name}")
      hash = JSON.parse(data.read)
      puts hash["gender"]
      if hash["gender"]
        item << hash["gender"]
      else
        item << "unknown"
      end
      results[hash["gender"]] += 1
      csv << item
    end
  end
end

File.open("genderresults.txt", "w") do |file|
  file.write results.to_s
end
