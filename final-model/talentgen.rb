require "csv"
#Constants
NAME_COLUMNS = [1]
TEAM_COLUMN = 3
WL_COLUMN = 4
DIFFERENCE_COLUMN = 5

#Helpers
def get_t(diff_s)
  a = Math.sqrt(2*Math::PI)*0.2051098
  b = Math::E**(-((diff_s+0.003809585)**2)/2*(0.2051098)**2)
  return a/b
end

sources = {}
teams = {}
CSV.foreach("football.csv") do |item|
  name = ""
  NAME_COLUMNS.each do |column|
    name += item[column]
  end
  if name.nil? || name.empty?
    next
  end
  
  team = item[TEAM_COLUMN]
  if item.nil? || item.empty?
    next
  end
  
  wl = item[WL_COLUMN]
  if wl.nil? || wl.empty?
    next
  end
  wl = wl.to_f
  
  difference = item[DIFFERENCE_COLUMN]
  if difference.nil? || difference.empty?
    next
  end
  difference = difference.to_f
  
  sources[name] ||= {}
  sources[name][:teams] ||= []
  sources[name][:teams] << {team: team, wl: wl, diff: difference}
  
  teams[team] ||= {}
  teams[team][:wls] ||= []
  teams[team][:wls] << wl
end

teams.each do |key, value|
  average = value[:wls].inject{ |sum, el| sum + el }.to_f / value[:wls].size
  
  inter = 0
  value[:wls].each do |wl|
    inter += (wl - average)**2
  end
  
  inter = inter / value[:wls].size
  inter = Math.sqrt(inter)
  value[:p] = inter
end

sources.each do |key, value|
  value[:teams].each do |exp|
    exp[:t] = get_t(exp[:diff])
    exp[:st] = exp[:wl]
    exp[:sta] = teams[exp[:team]][:p]
  end
  
  t_sum = 0.0
  st_sum = 0.0
  sta_sum = 0.0
  value[:teams].each do |exp|
    t_sum += exp[:t]
    st_sum += exp[:st]
    sta_sum += exp[:sta]
  end
  value[:bt] = t_sum / value[:teams].length
  value[:bst] = st_sum / value[:teams].length
  value[:bsta] = sta_sum / value[:teams].length
end

max_bt = 0.0
max_bst = 0.0
max_bsta = 0.0
sources.each do |key, exp|
  max_bt = exp[:bt] if exp[:bt] > max_bt
  max_bst = exp[:bst] if exp[:bst] > max_bst
  max_bsta = exp[:bsta] if exp[:bst] > max_bsta
end

results = {}
sources.each do |key, value|
  results[key] = (value[:bt]/max_bt)+(value[:bst]/max_bst)+(value[:bsta]/max_bsta)
end

CSV.open("scoreresult.csv", "wb") do |csv|
  results.each do |key, value|
    csv << [key, value]
  end
end