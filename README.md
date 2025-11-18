# duit_kernel

[![Coverage Status](https://coveralls.io/repos/github/Duit-Foundation/duit_kernel/badge.svg?branch=main)](https://coveralls.io/github/Duit-Foundation/duit_kernel?branch=main) ![Pub Version](https://img.shields.io/pub/v/duit_kernel) ![Pub Points](https://img.shields.io/pub/points/duit_kernel) 

Core library for the flutter_duit package. Contains basic models used in flutter_duit and which can be used to develop third-party extensions.

## Purpose

The library standardizes contracts between different system components, ensuring API stability and the ability to independently develop extensions without direct dependencies on specific implementations in `flutter_duit`.

## Package Structure

The package includes several key modules:

- **Action API** — system for handling actions and events, allowing execution of commands and processing user interactions with the interface
- **Animation API** — interfaces and models for working with widget and property animations
- **Driver API** — abstractions for UI driver, view management, and their display state
- **Registry API** — system for component registration and management, including build factories and component descriptions
- **Transport API** — transport layer interfaces for data exchange between client and server
- **UI** — basic models for representing UI tree, themes, and their application rules
- **View Attributes** — system for view attributes and data sources
- **Misc** — auxiliary utilities: logging, parsing, JSON Patch operations, script handling

This separation allows creating custom framework extensions (e.g., `duit_hetu_extension`) and alternative implementations within defined contracts, ensuring compatibility and stability of the Duit ecosystem.
