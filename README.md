# Apodini LIFX Example

This repository includes an example Apodini web service that can be used to control LIFX smart lights using [NIO LIFX](https://github.com/PSchmiedmayer/Swift-NIO-LIFX).  

## Build an Apodini Web Service

An Apodini web service is build using [Swift](https://docs.swift.org/swift-book/) and uses [Swift Packages](https://developer.apple.com/documentation/swift_packages). You can learn more about the Swift Package Manager at [swift.org](https://swift.org/package-manager/).

### macOS & Xcode

If you use macOS, you can use [Xcode](https://apps.apple.com/de/app/xcode/id497799835) to open the `Package.swift` file at the root of the repository using Xcode. You can learn more on how to use Swift Packages with Xcode on [developer.apple.com](https://developer.apple.com/documentation/xcode/creating_a_standalone_swift_package_with_xcode).

### Visual Studio Code on any operating system

If you are not using macOS or don't want to use Xcode, you can use [Visual Studio Code](https://code.visualstudio.com) using the [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) plugin. You must install the latest version of [Visual Studio Code](https://code.visualstudio.com), the latest version of the [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) plugin and [Docker](https://www.docker.com/products/docker-desktop).

1. Open the folder using Visual Studio Code
2. If you have installed the [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) plugin [Visual Studio Code](https://code.visualstudio.com) automatically asks you to reopen the folder to develop in a container at the bottom right of the Visual Studio Code window.
3. Press "Reopen in Container" and wait until the docker container is build
4. You can now build the code using the [build keyboard shortcut](https://code.visualstudio.com/docs/getstarted/keybindings#_tasks) and run and test the code within the docker container using the Run and Debug area.

## Structure

The web service exposes a RESTful web API and an OpenAPI description.  

It includes `Handler`s to 
- Send out discovery messages (`DiscoverDevices`)
- Get all devices that are currently discovered (`GetAllDevices`)
- Change the power level of a device (`ChangeDeviceState`).

In addition the Apodini web service includes a `Job` that is triggered every minute to discover new devices on the network (`DiscoveryJob`).

## RESTful API

- You can access the `DiscoverDevices` `Handler` at `http://localhost:8080/v1/discover` using a `POST` request.  
- You can access the `GetAllDevices` `Handler` at `http://localhost:8080/v1/devices` using a `GET` request.  
- You can access the `ChangeDeviceState` `Handler` at `http://localhost:8080/v1/devices/DEVICE_NAME` using a `PUT` request. The `DEVICE_NAME` in the path indicates the device's name you try to address. The `PUT` request must include the new state in the new state in the HTTP Body, e.g.:
```json
"on"
```

## OpenAPI

You can access the OpenAPI document at `http://localhost:8080/openapi`.  
The Swagger UI is also automatically generated and accessible at `http://localhost:8080/openapi-ui`.

## Continous Integration

The repository contains GitHub Actions to automatically build and test the example web service on a wide variety of platforms and configurations.
