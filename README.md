packer-storm
============

Build Apache (Incubator) [Storm](https://storm.incubator.apache.org/) with [packer](http://www.packer.io/). Made for AWS - could work with any packer backend.

Usage
-----

Make sure you have the AWS key and secret key environment variables and create a file called vars.json:

```json
{
    "nimbus_host": "hostname or IP",
    "zookeeper_server": "hostname or IP"
}
```

```bash
packer build -var-file=vars.json storm.json
```
