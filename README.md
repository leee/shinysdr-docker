# ShinySDR Docker

## Run

To build locally: `sudo docker build --tag shinysdr .`

```
sudo docker run --privileged --interactive --tty --publish 8100-8101:8100-8101/tcp --volume /canonical/path/to/config/dir/on/host:/app shinysdr
```

### Run Explanations:

- `--privileged`: needed to access SDRs. This is only confirmed working on Linux Docker hosts, one will not be able to pass through USB devices on macOS. One may be able to do something on Windows, but buyer beware.

- `--interactive --tty`: really to just support `C-c`.

- `--publish`: Optional. The Dockerfile exposes `8100/tcp` and `8101/tcp`, and publishing overrides `EXPOSE`.

- `--volume`: ShinySDR uses directories for configuration. If you don't already have a config directory, you should map a config directory as a volume, even if it's empty. This image will check for directory emptiness on runtime, and invoke `shinysdr --create` to create a new default config.

## Assumptions

We use the [W1MX/W1XM fork of ShinySDR](https://github.com/w1xm/shinysdr). We also install specific versions of `gr-dsd` and `gr-radioteletype` that were last known compatible with `gnuradio 3.8`.
