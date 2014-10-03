# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


admin1 = Account.create(email: 'admin1@email.com', password: 'defaultpw', admin: true)
account1 = Account.create(email: 'a1@email.com', password: 'defaultpw')
account2 = Account.create(email: 'a2@email.com', password: 'defaultpw')
account3 = Account.create(email: 'a3@email.com', password: 'defaultpw')

package_free          = Package.create(name: "Free", description: "This is free package", position:1, status: 1)
package_pro           = Package.create(name: "Pro", description: "This is Pro package", position:2, status: 1)
package_expert        = Package.create(name: "Expert", description: "This is expert package", position:3, status: 1)

package_free.limitations.create(key: 'maximum_surveys_count', description: 'Create 3 surveys', position: 1, status: 1, value: 3)
package_free.limitations.create(key: 'maximum_languages_count', description: 'Use 1 language for your survey', position: 2, status: 1, value: 1)
package_free.limitations.create(key: 'statistics', description: 'Survey statistics', position: 3, status: 1, value: 1)
package_free.limitations.create(key: 'maximum_space', description: '500MB space', position: 4, status: 1, value: 500)
package_free.limitations.create(key: 'embed', description: 'Embed your survey', position: 5, status: 0, value: 0)

package_pro.limitations.create(key: 'maximum_surveys_count', description: 'Create unlimited surveys', position: 1, status: 1, value: 0)
package_pro.limitations.create(key: 'maximum_languages_count', description: 'Use unlimited languages for your survey', position: 2, status: 1, value: 0)
package_pro.limitations.create(key: 'statistics', description: 'Survey statistics', position: 3, status: 1, value: 1)
package_pro.limitations.create(key: 'maximum_space', description: '5GB space', position: 4, status: 1, value: 5000)
package_pro.limitations.create(key: 'embed', description: 'Embed your survey', position: 5, status: 1, value: 1)

package_expert.limitations.create(key: 'maximum_surveys_count', description: 'Create unlimited surveys', position: 1, status: 1, value: 0)
package_expert.limitations.create(key: 'maximum_languages_count', description: 'Use unlimited languages for your survey', position: 2, status: 1, value: 0)
package_expert.limitations.create(key: 'statistics', description: 'Survey statistics', position: 3, status: 1, value: 1)
package_expert.limitations.create(key: 'maximum_space', description: '10GB space', position: 4, status: 1, value: 10000)
package_expert.limitations.create(key: 'embed', description: 'Embed your survey', position: 5, status: 1, value: 1)

plan_free           = Plan.create(name: "Free", price_cents: 0, status: 1, duration: 1, description: "This is free plan", position:1, package_id: package_free.id)

plan_pro_yearly     = Plan.create(name: "Pro",  price_cents: 49 * 100, status: 1, duration: 12, description: "This is pro plan", position:2, package_id: package_pro.id)
plan_pro_montly     = Plan.create(name: "Pro",  price_cents: 4.9 * 100, status: 1, duration: 1, description: "This is pro plan", position:3, package_id: package_pro.id)

plan_expert_yearly  = Plan.create(name: "Expert", price_cents: 62 * 100, status: 1, duration: 12, description: "This is expert plan", position:4, package_id: package_expert.id)
plan_expert_monthly = Plan.create(name: "Expert", price_cents: 6.49 * 100, status: 1, duration: 1, description: "This is expert plan", position:5, package_id: package_expert.id )