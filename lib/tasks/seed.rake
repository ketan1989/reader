namespace :seed do
    
  #rake seed:db
  
  task :db => :environment do |t, args|
    puts "Seeding"
    u = User.new(email: "ritvij.j@gmail.com", password: "xxxxxxx234", name: "Super Admin", username: "pykih123", slug: "admin", is_paying_customer: true)
    u.skip_confirmation!
    u.save
  end
  
end