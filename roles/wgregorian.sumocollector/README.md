Role Name
=========

Ansible role to install SumoCollector. This role was inspired by modcloth's SumoCollector role, but it goes one step further by including the ability to include additional log paths.

Role Variables
--------------

Default variables:

```
# For RedHat only
sumocollector_installer_rpm: "https://collectors.sumologic.com/rest/download/rpm/64"
sumologic_installer_rpm_local_folder: "/tmp"

# For Debian apt installation only
sumologic_installer_remote_file: "/tmp/sumocollector.deb"
sumocollector_installer_download: "https://collectors.sumologic.com/rest/download/deb/64"

# Credentials
sumologic_collector_accessid: "{{ lookup('env', 'SUMO_COLLECTOR_ACCESS_ID' }}"
sumologic_collector_accesskey: "{{ lookup('env', 'SUMO_COLLECTOR_ACCESS_KEY' }}"


# Allow overwrite of old collectors. See:
#   https://service.sumologic.com/help/Default.htm#Using_Clobber.htm
sumologic_collector_clobber: ""

sumologic_installer_file: ""
sumologic_collector_source_template: "collector.json.j2"
sumologic_collector_timezone: "UTC"
sumologic_collector_force_timezone: "false"
sumologic_collector_default_log_path:
  - name: "EXAMPLE LOG"
    path: "/var/log/EXAMPLE.log"
    use_multiline: false
    category: "EXAMPLE"
```

Group variable example:

```
sumologic_collector_application_log_path:
  - name: "APP LOG"
    path: "/var/log/APP.log"
    use_multiline: false
    category: "APP" }
```

Example Playbook
----------------

You can add the role

    - hosts: servers
      roles:
         - role: wgregorian.sumocollector

Installation can be done via ansible-galaxy:

    ansible-galaxy install wgregorian.sumocollector

Or automated by creating a `requirements.yml` with this block:

    - src: wgregorian.sumocollector

and running:

    ansible-galaxy install -r requirements.yml


License
-------

MIT

Author Information
------------------

William Gregorian - CISO, FutureAdvisor.
