⚠️ **Note: This Addon is belong to tinymation.com service.**

# Hass Addon - Remote HA
Home Assistant Community Add-on: Remote Home Assistant

You can leverage this add-on to achieve remote access to local Home Assistant OS.

## Installation
- Go to Settings -> Add-ons -> Add-on Store (bottom right)

- Click Repositories (top right)

- Add the current repository 

- Wait and refresh the Add-on Store page, then you can see one new add-on `Remote HA`, click it and install

- Add the configurations shown as below in your `configurations.yaml` with File Editor addon
```
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 0.0.0.0/0
```

## Try it now
[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fkhongpt%2FRemote-HA.git)

## Version
- 1.0.1 @2024

