{% set hostname = salt['grains.get']('nodename') -%}
{% set ssh_users = salt['pillar.get']('devops_generic_users:name') %}
{% set publickey = salt['pillar.get']('devops_generic_users:publickey') %}

{% if grains['id'] == 'TT-SKUB-LORNG07' and grains['localhost'] == 'ttskublorng07' %}
k8s_node_drain:
  cmd.run:
    - name: echo {{ hostname }}
{% elif grains['id'] == 'TT-SKUB-LORNG06' and grains['localhost'] == 'ttskublorng06' %}
k8s_node_drain_on_master:
# { % set master1_ip = salt['cmd.shell'](('echo $(cat /etc/kubernetes/kubeadm-client.conf | grep apiServerEndpoint | awk -F: '{ print $2 }' | tr -d " |\n\"")') % } #
{% set load_avg = salt['cmd.shell']('uptime | sed "s/.*load average: //" | cut -d " " -f2 | cut -d . -f1') %}
  cmd.run:
    # - name: echo "i am the master" by {{ssh_users}} and here is {{ publickey }}
    - name: {{ ssh_users }} and {{ load_avg }}
{% endif %}