setup:
	bundle
	bin/rails assets:precompile
	bin/rails db:migrate
	bin/rails db:seed
start:
	bin/rails s