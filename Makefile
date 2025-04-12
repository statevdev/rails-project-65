setup:
	bundle
	bin/rails assets:precompile
	bin/rails db:migrate
	bin/rails db:seed
start:
	bin/rails s
lint:
	bundle exec rubocop
	bundle exec slim-lint app/views/
tests:
	bin/rails test