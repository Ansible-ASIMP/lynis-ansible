# lynis-ansible

Ansible snippets and code for Lynis

* Lynis

Lynis is a security auditing tool for systems running Linux, Mac OS X, BSD, or some other UNIX-derivative.

This repository is supported by community contributions.

Example

```
---
- hosts: localhost
  gather_facts: true
  roles:
    - {role: lynis-ansible, lynis_use_packages: yes, lynis_audit_system_linux: yes}
```
