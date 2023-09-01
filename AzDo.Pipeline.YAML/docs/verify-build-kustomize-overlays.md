# verify-build-kustomize-overlays.yaml
The main aim of this template is to verify and build manifest files for all the overlays (based on the input of the user in pipeline).
Here, we have not hardcoded any values in the template and can be passed as parameters using the pipeline yaml. 

# Reference
You can please refer [tests](https://dev.azure.com/intlfcstone/Innersource/_git/AzDo.Pipeline.YAML?path=/tests) for the structure of the pipeline. 

# Usage
To reference this template in your own pipeline, you would register the repository under an alias (here, `innersource`)

```yaml
resources:
  repositories:
    - repository: innersource
      type: git
      name: Innersource/AzDo.Pipeline.YAML
      ref: refs/tags/stages/jobs/verify-build-kustomize-overlays.yaml.v2  # optional, but encouraged
        #  add a specific git reference to lock-in
        #  your template and not update when the template
        #  changes. Highly encouraged!
```

...and then reference the template in your job from that alias:

```yaml
jobs:
  - template: stages/jobs/verify-build-kustomize-overlays.yaml@innersource
    parameters:
      overlayDir: 'dsc/overlays'
      overlays:
      - uat
      - prod
```
:bulb: Highly recommend to pass the overlay names in the form of list.