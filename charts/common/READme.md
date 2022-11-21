# Testkube Common Library Chart

A [Library Chart](https://helm.sh/docs/topics/library_charts/#helm) for definitions that can be shared by Helm templates in other charts.
##Usage
```sh
dependencies:
  - name: common
    version: 1.x.x
    repository: https://kubeshop.github.io/helm-charts
```

``
$ helm dependency update
``

```sh
apiVersion: v1
kind: ConfigMap
metadata:
name: {{ include "common.names.fullname" . }}
data:
myvalue: "Hello World"
```

##Prerequisites
- Helm 3.0.0+

