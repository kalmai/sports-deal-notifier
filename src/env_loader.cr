ENV.clear

File.read("#{Path[__DIR__].parent}/.env").split.each do |set|
  first_eql = set.index("=") # we don't use split here in case there are '='s in values
  key = set[...first_eql]
  value = set[(first_eql.try { |num| num + 1 })..]
  ENV[key] = value
end

puts "ENV loaded for '#{ENV.fetch("ENVIRONMENT")}'"
