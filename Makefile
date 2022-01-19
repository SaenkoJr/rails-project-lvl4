ARGS = $(filter-out $@,$(MAKECMDGOALS))
%:
	@:

install:
	bundle install

setup:
	bin/setup
	bin/rails db:fixtures:load

start:
	rm -rf tmp/pids/server.pid
	bundle exec rails s -b '0.0.0.0' -p 5000

ngrok:
	ngrok http 5000

lint:
	bundle exec rubocop
	bundle exec slim-lint app/views

lint-fix:
	bundle exec rubocop --auto-correct

test:
	bin/rails test $(ARGS)

restart:
	bin/rails restart

heroku-start:
	bundle exec heroku local

heroku-rails-console:
	heroku run rails console

heroku-logs:
	heroku logs --tail

.PHONY: test
