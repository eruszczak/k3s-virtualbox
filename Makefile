default: vagrant provision

console:
	ansible-console --inventory inventory.yml

provision:
	ansible-playbook site.yml --inventory inventory.yml
	kubectl config set-context k3s-virtualbox

vagrant:
	vagrant up

argocd:
	helm upgrade --install argocd cluster/argocd/ --namespace=argocd --create-namespace --wait
	# [helm --wait is enough] kubectl wait deployment -n argocd argocd-server --for condition=Available=True --timeout=120s
	helm upgrade --install argocd-apps cluster/argocd-apps/ --namespace=argocd --wait

destroy:
	vagrant destroy --force
	# rm -rf .vagrant*
	kubectl config delete-context k3s-virtualbox
	kubectl config delete-cluster k3s-virtualbox
	kubectl config delete-user k3s-virtualbox

clean-cluster:
	helm uninstall argocd-apps --namespace=argocd
	helm uninstall argocd --namespace=argocd

ingressip:
	kubectl get services --namespace ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'