setup:
	bundle install
	rails db:create db:migrate db:seed

dev:
	rails s -p 3000

test:
	bundle exec rspec

lint:
	bundle exec rubocop

db-migrate:
	rails db:migrate

db-rollback:
	rails db:rollback

console:
	rails console

.PHONY: setup dev test lint db-migrate db-rollback console
