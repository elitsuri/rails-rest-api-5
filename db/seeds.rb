# db/seeds.rb
puts 'Seeding...'

admin = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.name     = 'Admin User'
  u.password = 'Password1!'
  u.role     = :admin
end
puts "Admin: #{admin.email}"

5.times do |i|
  user = User.find_or_create_by!(email: "user#{i}@example.com") do |u|
    u.name     = "User #{i}"
    u.password = 'Password1!'
  end
  3.times do |j|
    user.items.find_or_create_by!(title: "Item #{i}-#{j}") do |item|
      item.description = "Description for item #{i}-#{j} with enough text"
      item.price       = (j + 1) * 9.99
    end
  end
end
puts 'Done!'
