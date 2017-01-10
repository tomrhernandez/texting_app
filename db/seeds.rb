# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Store.create(name: "First Pharmacy", phone: "14043419132", nabp: "1111111")
Store.create(name: "Second Pharmacy", phone: "14043419117", nabp: "2222222")

### Simulated messages to and from Patient and Pharmacy ###


Message.create(to: "14043419132", from: "16168813870", message: "Please refill all my medications", store_id: 1)
Message.create(to: "16168813870", from: "14043419132", message: "Your medications are ready for pick up. Thank you and have a nice day!", store_id: 1, qs_read: true)
Message.create(to: "14043419132", from: "16168813870", message: "Refill my blood pressure medicine", store_id: 1)
Message.create(to: "16168813870", from: "14043419132", message: "Your blood pressure medication is ready for pick up. Thank you and have a nice day!", store_id: 1, qs_read: true)
Message.create(to: "14043419132", from: "16168813870", message: "Do I have any refills on my Lisinopril?", store_id: 1)
Message.create(to: "16168813870", from: "14043419132", message: "You have one refill left, would you like to get it filled?", store_id: 1, qs_read: true)
Message.create(to: "14043419132", from: "16168813870", message: "Need refills for mine and my wife's prescriptions, thank you", store_id: 1)
Message.create(to: "16168813870", from: "14043419132", message: "All your medications are ready. Thank you and have a nice day!", store_id: 1, qs_read: true)

for message in Message.all
    message.update(store_id: 1)
    if message.id % 2 == 0
        message.update(qs_read: true)
    end
    message.save
end