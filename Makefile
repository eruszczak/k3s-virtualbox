default: vagrant playbook

console:
	ansible-console --inventory inventory.yml

playbook:
	ansible-playbook site.yml --inventory inventory.yml 

vagrant:
	vagrant up

clean:
	vagrant destroy --force && rm -rf .vagrant*

k3s:
	# ansible-playbook roles/k3sup/tasks/main.yml
	ansible-playbook roles/k3sup/tasks/main.yml --inventory inventory.yml