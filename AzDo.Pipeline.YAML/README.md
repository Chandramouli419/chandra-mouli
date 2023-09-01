# AzDo.Pipeline.YAML
A repository to share [Azure DevOps Pipeline Templates](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/templates).

# Usage
To reference these build/deployment tasks in your own pipelines, you would register this repository under an alias (here, `innersource`)
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

...and then reference a specific template in your Job/Task/etc from that alias:
```yaml
jobs:
- job:
  - template: stages/jobs/steps/kustomize-publish-overlay.yml@innersource
    parameters:
      overlayName: 'dev'
      overlayDir: 'dsc/overlays'
```

For more examples, try out the [official Microsoft docs](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/templates?view=azure-devops#using-other-repositories).

# Contribute
Have an addition to make? Create a Pull Request and notify [DevOps](mailto:dg-devops@intlfcstone.com)! Here are a few things to keep in mind:

1. Templates are specific to a pipeline object - either a set of Stages, a set of Jobs (1 Stage), or a set of Steps (1 Job). Be sure that the template you are creating is placed at the proper directory structure level.
1. Templates names should:
  - contain only lower-case letters and hyphens
  - be prefixed with the tool or technology stack they assist with (e.g. 'git', 'dotnetcore', 'npm', 'k8s', 'docker', etc)
1. Template content should contain:
  - a well-formatted header that provides a brief description of what the template does
  - a `parameters` section outlining all required parameters with reasonable defaults