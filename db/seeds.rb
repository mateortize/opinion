# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


admin1 = Account.create(email: 'admin1@email.com', password: 'defaultpw', admin: true)


plan1 = Plan.create(name: "Free", price_cents: 0, status: 1, duration: 1, description: "This is free plan")
plan2 = Plan.create(name: "Pro", price_cents: 10 * 1000, status: 1, duration: 1, description: "This is pro plan")
plan3 = Plan.create(name: "Expert", price_cents: 20 * 1000, status: 1, duration: 1, description: "This is expert plan")

Account.create(email: 'a1@email.com', password: 'defaultpw')
Account.create(email: 'a2@email.com', password: 'defaultpw')
Account.create(email: 'a3@email.com', password: 'defaultpw')


pro1 = Account.create(email: 'p1@email.com', password: 'defaultpw')
pro1.plan = Plan.pro
pro1.save

expert1 = Account.create(email: 'e1@email.com', password: 'defaultpw')
expert1.plan = Plan.expert
expert1.save

free1 = Account.create(email: 'f1@email.com', password: 'defaultpw')
free1.plan = Plan.expert
free1.save