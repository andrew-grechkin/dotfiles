# Filters

- filter by label
    ```bash
    kubectl get release -l label=value
    ```
- get unhealthy pods
    ```bash
    kubectl get pods --field-selector=status.phase!=Running
    ```

# Order

- sort by age
    ```bash
    kubectl get rs --sort-by=.metadata.creationTimestamp --no-headers | tac
    ```

# Deployments

- check deployment history:
    ```bash
    $ kubectl rollout history "deployment/${APP_NAME}"
    "deployment/${APP_NAME}"
    REVISION  CHANGE-CAUSE
    1         Reason 1
    2         Reason 2
    ```
- set image for a container:
    ```bash
    $ kubectl set image "deployment/${APP_NAME}" <container-name>=<image:tag>
    $ kubectl annotate "deployment/${APP_NAME}" "kubernetes.io/change-cause=image changed manually by ${USER}"
    ```
- scale replicas:
    ```bash
    $ kubectl scale --replicas <num> "deployment/${APP_NAME}"
    ```
- monitor ongoing rollout:
    ```bash
    $ kubectl rollout status "deployment/${APP_NAME}"
    ```
- pause and resume ongoing rollout:
    ```bash
    $ kubectl rollout pause "deployment/${APP_NAME}"
    $ kubectl rollout resume "deployment/${APP_NAME}"
    ```
- revert deployment changes:
    ```bash
    $ kubectl rollout undo "deployment/${APP_NAME}"

    $ kubectl rollout undo "deployment/${APP_NAME}" --to-revision=1
    ```

# Labels

- set a new label:
    ```bash
    $ kubectl label "service/${APP_NAME}" key=value
    ```
- overwrite an existing label:
    ```bash
    $ kubectl label "service/${APP_NAME}" --overwrite key=value
    ```
- remove a label if exists:
    ```bash
    $ kubectl label "service/${APP_NAME}" key-
    ```
- set label to the all objects of a kind:
    ```bash
    $ kubectl label pods --all key=value
    ```
- set label for objects identified by a file:
    ```bash
    $ kubectl label -f pod.json key=value
    ```
