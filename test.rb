require 'csv'
CSV.foreach('test.csv', :headers => true) do |row|
  r=row.to_hash
  p=r.first[1].gsub 'POLYGON Z', 'POLYGON'
  p=p.gsub ' 0,', ', '
  p=p.gsub ' 0)', ')'
  if p[0..3]=="POLY" then
    p=p.gsub 'POLYGON ','MULTIPOLYGON ('
    p=p+')'
  end
  desc=r['Legislation']
  if desc then desc=desc+" " else desc="" end
  if r['Section'] then 
    desc=desc+r['Section']
  end
  Park.create(boundary: p, name: r['Name'], description: desc);0
  puts p
end
  
