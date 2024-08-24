# Proposed: Elixir Livebook on Fedora 39

## Metadata

- **Status**: Proposed
- **Deciders**: V-Sekai Team
- **Tags**: `Elixir`, `Livebook`, `Fedora 39`

## Backdrop

The goal is to utilize Elixir NX for data science and numerical computing applications relevant to V-Sekai.

## Challenge

The challenge lies in ensuring a successful installation and configuration of Elixir Livebook on Fedora 39, which will serve as a development platform.

## Strategy

- Assess compatibility between Elixir Livebook and Fedora 39.
- Identify all dependencies required for Elixir Livebook.
- Develop comprehensive guidelines for the installation process.
- Conduct a test run of the install procedure on a Fedora 39 system.

Create a dedicated user for running Livebook and determine an appropriate location for the installation, such as `/opt/livebook`.

```bash
sudo yum groupinstall -y 'Development Tools' 'C Development Tools and Libraries'
sudo dnf install -y \
  autoconf \
  ncurses-devel \
  wxGTK3-devel \
  wxBase3 \
  openssl-devel \
  java-1.8.0-openjdk-devel \
  libiodbc \
  unixODBC-devel.x86_64 \
  erlang-odbc.x86_64 \
  libxslt \
  fop \
  automake \
  readline-devel \
  git \
  gcc \
  unzip \
  curl
sudo dnf copr enable vbatts/bazel -y && dnf install bazel5 -y
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda -y

# As root or using sudo
useradd --system --create-home --home-dir /opt/livebook livebook
chown -R livebook: /opt/livebook
su - livebook
cd /opt/livebook
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
source ~/.bashrc
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang 26.2.1
asdf global erlang 26.2.1
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir 1.16-otp-26
asdf global elixir 1.16-otp-26
erl -version
elixir -v
mix do local.rebar --force, local.hex --force
mix escript.install hex livebook --force
```

To insert or overwrite the existing systemd service configuration for Elixir Livebook directly from the shell, you can use the following commands:

First, open your terminal and use `cat` combined with a here-document to overwrite the file with the new configuration:

```bash
sudo cat > /etc/systemd/system/livebook.service <<EOF
[Unit]
Description=Elixir Livebook server
After=network.target

[Service]
User=livebook
WorkingDirectory=/opt/livebook
ExecStart=/bin/bash -c '. /opt/livebook/.asdf/asdf.sh && exec /opt/livebook/.asdf/installs/elixir/1.16-otp-26/.mix/escripts/livebook server'
Environment=MIX_ENV=prod
Environment=LIVEBOOK_PORT=8080
Environment=LIVEBOOK_IP=0.0.0.0
Environment=LIVEBOOK_HOME=/opt/livebook
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
```

Ensure that you have the necessary permissions to write to `/etc/systemd/system/`.

After saving the file, reload systemd to apply the changes:

```bash
sudo systemctl daemon-reload
sudo systemctl enable livebook.service
sudo systemctl restart livebook.service
```

Verify that the service is running correctly with:

```bash
sudo systemctl status livebook.service # Check this for the authentication token.
```

Debug the service with journalctl.

```bash
sudo journalctl -u livebook.service
```

Remember to adjust the path specified in the `ExecStart` directive if required and set any additional environment variables as needed.

## Upside

- Provides a real-time collaborative tool for Elixir development.
- Helps in verifying Elixir NX’s capabilities through visualization.
- Streamlines the code development cycle with instant feedback.

## Downside

- Time allocation needed for the seamless functioning of Livebook on Fedora 39.
- Dependencies might add a layer of complexity in ongoing maintenance.
- The initial setup could pose challenges for non-expert users.

## Road Not Taken

Other tools and languages were assessed but did not fulfill V-Sekai's requirements as effectively as Elixir Livebook.

## Infrequent Use Case

Evaluating occasional usage to justify the demand for an efficient installation approach.

## In Core and Done by Us?

Determining if this integration should be centralized within V-Sekai's primary offerings and whether internal resources can achieve this implementation.

## Further Reading

1. [V-Sekai · GitHub](https://github.com/v-sekai) - Official GitHub account of V-Sekai's developer community.
2. [V-Sekai/v-sekai-game](https://github.com/v-sekai/v-sekai-game) - Repository dedicated to V-Sekai's project for merging social VR and metaverse elements with Godot Engine.

_Aria, an AI assistant, contributed to the drafting of this proposal._
