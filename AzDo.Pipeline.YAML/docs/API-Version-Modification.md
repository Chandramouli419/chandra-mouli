# API-Version-Modification.yaml
The main aim of this template is to modify the API version of the specified file (based on the input of the user in pipeline).
Here, we have not hardcoded any values in the template and can be passed as parameters using the pipeline yaml. 

# Usage
To reference this template in your own pipeline, you would register the repository under an alias (here, `innersource`). 
It creates a new deployBranch (specified by the user) to upload the modified file. 
It also stores the original file as a backup which can later be deleted after validating the new file and can be merged with master


```yaml
resources:
  repositories:
    - repository: innersource
      type: git
      name: Innersource/AzDo.Pipeline.YAML
      #ref: refs/tags/v1.0 - optional: add a specific git reference to lock-in
      #                      your template and not update when the template
      #                      changes. Highly encouraged!
```

...and then reference the template in your job from that alias:

```yaml
jobs:
  - template: stages/jobs/API-Version-Modification.yaml@innersource
    parameters:
        RemoteURL : https://intlfcstone@dev.azure.com/intlfcstone/DevOpsAutomationTest/_git/HarshaPlay
        deployBranch : Testing
        RepositoryName : HarshaPlay
        FilePath : base/Ingress.yaml
        NewAPIVersion: networking.k8s.io/v1
```