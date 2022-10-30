{% import 'roles/vars.sls' as roles with context -%}

{% if grains['roles']['_role'] == 'worker' && grain['roles']['_service'] == 'kubernetes' %}

k8s_node_uncordon:
  cmd.run:
    - name: kubectl uncordon {{ roles['hostname'] }}


{% endif %}