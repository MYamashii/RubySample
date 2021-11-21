file = File.open("#{__dir__}/terraform_sample/sample.tf", 'r')
organization_members = []

file.each do |line|
  
  splits = line.split(' ')
  # ["username", "=", "\"SomeUser\""]の場合を考える
  organization_members <<splits[2] if splits.include?('username')
end

uniqued_organization_members =  organization_members.uniq

outside_collaborator_file = File.open("#{__dir__}/terraform_sample/sample_outside_collaborator.tf", 'r')
collaborator_members = []

outside_collaborator_file.each do |line|
  
  splits = line.split(' ')
  # membershipと同様に同様に["username", "=", "\"SomeUser\""]の場合を考える
  collaborator_members <<splits[2] if splits.include?('username')
end

uniqued_collaborator_members =  collaborator_members.uniq

puts "uniqued_organization_members: #{uniqued_organization_members}"
puts "uniqued_collaborator_members: #{uniqued_collaborator_members}"
