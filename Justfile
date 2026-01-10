# Dotfiles VM Testing Workflow
#
# Setup (one-time):
#   just vm-build
#
# Testing workflow:
#   just vm-test-create
#   just vm-test-run[-headless]
#   just vm-test-ssh
#   <test chezmoi apply, etc>
#   just vm-test-reset
#   just vm-test-clean
#

default_macos := "tahoe"

# --- Golden Master (Packer-built base image) ---

vm-build macos_version=default_macos:
    packer init vm/bootstrap.pkr.hcl
    packer build -var "macos_version={{macos_version}}" vm/bootstrap.pkr.hcl

vm-validate:
    packer validate vm/bootstrap.pkr.hcl

vm-clean macos_version=default_macos:
    -tart delete {{macos_version}}-bootstrap

vm-list:
    @tart list

# --- Test VM (disposable clone for testing) ---

vm-test-create macos_version=default_macos:
    tart clone {{macos_version}}-bootstrap {{macos_version}}-test

vm-test-run macos_version=default_macos:
    tart run \
        --net-bridged=en0 \
        --dir=dotfiles:$(chezmoi source-path):ro \
        {{macos_version}}-test

vm-test-run-headless macos_version=default_macos:
    tart run \
        --net-bridged=en0 \
        --no-graphics \
        --dir=dotfiles:$(chezmoi source-path):ro \
        {{macos_version}}-test &

vm-test-stop macos_version=default_macos:
    tart stop {{macos_version}}-test

vm-test-ssh macos_version=default_macos:
    ssh -A -o StrictHostKeyChecking=no admin@$(tart ip --resolver=arp {{macos_version}}-test)

vm-test-reset macos_version=default_macos:
    -tart stop {{macos_version}}-test
    -tart delete {{macos_version}}-test
    tart clone {{macos_version}}-bootstrap {{macos_version}}-test

vm-test-clean macos_version=default_macos:
    -tart stop {{macos_version}}-test
    -tart delete {{macos_version}}-test
