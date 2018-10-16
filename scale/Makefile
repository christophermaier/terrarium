TERRARIUM_NETWORK_SIZE ?= 15

CTL_SECRET:
	hab sup secret generate > CTL_SECRET

docker-compose.yml:
	./scripts/generate_compose.sh $(TERRARIUM_NETWORK_SIZE) > $@
	docker-compose config --quiet

.tmuxinator.yml:
	./scripts/generate_tmuxinator.sh $(TERRARIUM_NETWORK_SIZE) > $@

setup: CTL_SECRET docker-compose.yml .tmuxinator.yml
	../scripts/setup.sh

clean:
	../scripts/cleanup.sh
	rm -f CTL_SECRET
	rm -f docker-compose.yml
	rm -f .tmuxinator.yml

start:
	tmuxinator start

stop:
	tmuxinator stop scale

refresh: clean setup start
