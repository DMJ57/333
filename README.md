# 333

jobs:
  trigger-workflow:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Another Workflow
        uses: peter-evans/workflow-dispatch@v1
        with:
          repository: your-repo-name
          workflow: another-workflow.yml  # The workflow to trigger
          ref: refs/heads/main  # The branch to use for the workflow
