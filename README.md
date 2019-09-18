# PromQL Resource

Implements a resource that reports new versions on a configured PromQL (Prometheus Query Language) query.

## Source Configuration

* `endpoint`: *Required.* Prometheus server URL like `https://prometheus.example.com`.

* `query`: *Required.* Prometheus expression query string.

  e.g.

  ```
  query: prometheus_tsdb_head_max_time{job="prometheus"}
  ```

* `skip_ssl_verification`: *Optional.* Skip SSL verification for Prometheus endpoint.

* `username` and `password`: *Optional.* Enable basic authentication to the Prometheus endpoint.

## Behavior

### `check`: Check for new value for the given query.

Reports the current value for the query configured in `source`.

### `in`: Report the given query.

Executes the given query, writing the request's metadata to `input` in the destination.

#### Parameters

*None.*

#### Files created by the resource

The resource will produce the following files:

* `./value`: A file containing the Promehteus query value.
* `./timestamp`: A file containing the Prometheus query execution timestamp.

### `out`: Not implmented.

## Pipeline example

```yaml
---
jobs:
- name: job-scale-app-instances
  public: true
  serial: true
  plan:
  - get: free-ram-metric
    trigger: true
  - task: scale
    file: web-app/scale.yml

resource_types:
- name: promql-resource
  type: registry-image
  source:
      repository: andreikrasnitski/concourse-promql-resource
      tag: latest

resources:
- name: free-ram-metric
  type: promql-resource
  source:
    endpoint: https://prometheus.example.com
    query: avg(cf_app_mem_percent{cf_app_name="my-awesome-app") by(environment, cf_app_name) > 90
```
