# {% set hostname = salt['grains.get']('nodename') -%}

# {% if grains['id'] == 'minion1' and grains['localhost'] == 'minion1' %}
# k8s_node_drain:
#   cmd.run:
#     - name: echo {{ hostname }}
# {% elif grains['id'] == 'minion2' and grains['localhost'] == 'minion2' %}

{% import 'roles/vars.sls' as roles with context -%}

{% if grains['roles']['_role'] == 'master' and grain['roles']['_service'] == 'kubernetes' %}

k8s_node_drain_on_master:
  cmd.run:
    # - name: kubectl uncordon {{ roles['hostname'] }}
    - name: echo {{ roles['hostname'] }} && kubectl drain {{ roles['hostname'] }} --ignore-daemonsets --delete-emptydir-data

{% elif grains['roles']['_role'] == 'worker' and grain['roles']['_service'] == 'kubernetes' %}

k8s_node_drain_on_master:
  cmd.run:
    - name: |
        MASTER1=$(grep apiServerEndpoint  /etc/kubernetes/kubeadm-client.conf kubeadm-controlplane.yaml 2> /dev/null | awk -F: '{print $3}' | tr -d " |\n\"")
        echo [Master] > /tmp/inventory.ini
        echo $MASTER1 >> /tmp/inventory.ini
        cat <<-EOF > /tmp/playbook.yml
        - hosts: Master[0]
          become: true
          tasks:
            - name: Mark node "specified worker node" as unschedulable.
              command: kubectl drain {{ roles['hostname'] }} --ignore-daemonsets --delete-emptydir-data
              register: drain_node
        EOF
        cat <<-EOF > /tmp/devops.pem
        -----BEGIN RSA PRIVATE KEY-----
        asdfghjklşsdfghjıkopğdftyuıopğüfgtyuıopğüfghjuıop
        asdfghjkloşi,wertyuıopğüsdfghjklşi,dfghjkloşiğrty
        asdfghjklşsdfghjıkopğdftyuıopğüfgtyuıopğüfghjuıop
        asdfghjkloşi,wertyuıopğüsdfghjklşi,dfghjkloşiğrty
        asdfghjklşsdfghjıkopğdftyuıopğüfgtyuıopğüfghjuıop
        asdfghjkloşi,wertyuıopğüsdfghjklşi,dfghjkloşiğrty
        asdfghjklşsdfghjıkopğdftyuıopğüfgtyuıopğüfghjuıop
        asdfghjkloşi,wertyuıopğüsdfghjklşi,dfghjkloşiğrty
        -----END RSA PRIVATE KEY-----
        EOF
        chmod 400 /root/.ssh/devops.pem
        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /tmp/inventory.ini /tmp/playbook.yml --private-key=~/tmp/devops.pem -u user || ANSIBLE_HOST_KEY_CHECKING=False /opt/venv/common/bin/ansible-playbook -i /tmp/inventory.ini /tmp/playbook.yml --private-key=~/tmp/devops.pem -u user
        sleep 30
delete created resources:
  cmd.run:
    - name: rm -rf /tmp/inventory.ini /tmp/playbook.yml /tmp/devops.pem
{% endif %}
