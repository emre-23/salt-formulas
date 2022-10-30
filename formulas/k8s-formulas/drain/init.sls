{% import 'roles/vars.sls' as roles with context -%}

{% if grains['roles']['_role'] == 'worker' && grain['roles']['_service'] == 'kubernetes' %}
# k8s_node_draim:
#     kubernetes.node_status:
#       - node_name: {{ roles['hostname'] }}
#       - availability: drain

k8s_node_drain:
  cmd.run:
    - name: kubectl drain {{ roles['hostname'] }} --ignore-daemonsets --delete-emptydir-data


{% endif %}