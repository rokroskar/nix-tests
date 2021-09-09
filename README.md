# Nix derivations for renku

This repository includes several [nix](https://nixos.org/) derivations
for renku.

## Quick start

Install nix (see [installation instructions](https://nixos.org/manual/nix/stable/#chap-installation)):

```shell
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
```

Use a shell with renku, the jupyter stack, and other essential utilities (e.g.
git) inside - this mimicks a typical renku interactive environment:

```shell
nix-shell
```

Build, load, and run a docker image that is equivalent to the usual Renku base
python image and can be used for interactive sessions on a Renku instance:

```shell
nix-build renkulab-docker-py.nix
docker load < result
docker run --rm -ti -p 8888:8888 renkulab-py
```

Build a docker image with just renku inside:

```shell
nix-build renku-docker.nix
docker load < result
```

Clean up the nix store:

```shell
nix-store --gc
```

Note: the garbage collection will remove all paths from the nix store that are
not associated with a "result". If you have a `result` link in your directory
(as a leftover from one of the above commands) the dependencies it requires will
not be garbage-collected.

## Using on MacOS and configuring remote builders

Doing the quick-start above on MacOS is not so... quick. If you want to build
docker images, you need to enable a [remote
builder](https://nixos.org/manual/nix/unstable/advanced-topics/distributed-builds.html)
capable of building for `x86_64-linux`.

### Remote builder on a VM

If you have access to a Linux VM, the easiest is to spin up a bare-bones linux
box, install nix and configure passwordless ssh keys. It's helpful at this point
to also set up the builders in `/etc/nix/machines` as well as configure the
server host in your `~/.ssh/config` for easier access. For example, the
`/etc/nix/machines` should be something like:

```
ssh://nix-builder x86_64-linux <path-to-ssh-key> 1 1 kvm,big-parallel
```

and `~/.ssh/config` like:

```
Host nix-builder
   Hostname 1.1.1.1
   User debian
   IdentityFile <path-to-ssh-key>
```

If you want to use kvm features on the builder (to, e.g. use `runAsRoot` in the docker image build) you need
to install kvm and manage the permissions for your default non-root user. For example, on debian:

```
sudo apt-get install --no-install-recommends \
    qemu-system \
    qemu-kvm \
    libvirt-clients \
    libvirt-daemon-system

sudo adduser $USER libvirt

sudo adduser $USER kvm
```

Once this is enabled, the `kvm` system feature will automatically be added to the builder.

### Remote builder using linuxkit-nix

An alternaive to the remote VM is to use
[linuxkit-nix](https://github.com/nix-community/linuxkit-nix). This project
takes advantage of native hyperkit on mac to spin up a lightweight linux VM. If
you manage to get it working, this is certainly the easier approach.

## TODO

Several things still need to be improved:

1. configure the jupyter image such that a user can execute `pip install` --> this is currently not possible
2. refactor to allow a custom base image to be injected at build time - this requires downloading the image and calculating its sha256 with nix before initiating the build
3. enable some sort of enhanced shell e.g. [powerline-go](https://github.com/justjanne/powerline-go)
4. create an image with RStudio
