require 'csv'

file = "#{Rails.root}/public/decidim4cs_users.csv"

users = Decidim::User.where("officialized_as is NOT NULL").select("id, email").to_a

headers = ["id", "email_sha256"]

CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
  users.each do |user|
  writer << [user.id, Digest::SHA256.hexdigest(user.email)]
  end
end
