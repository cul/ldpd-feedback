# CUL Feedback

Feedback app for CUL sites.

## Local Development

Run the application with `bin/dev` command which starts both the server and dartsass:watch.

## Setup

Set up your local credentials for development and test by running this command:

```
VISUAL="code --wait" bin/rails credentials:edit --environment development
```

and

```
VISUAL="code --wait" bin/rails credentials:edit --environment test
```

Note: `VISUAL="code --wait"` will open the credentials file using VSCode. To use Vim, replace VISUAL variable with `EDITOR=vim`
