## 4.3.0

- Added toEnum and toClass methods

## 4.2.3

- Add action suppression caching logic for idempotent ServerAction

## 4.2.2

- Add cacheTTL to ServerAction and preparePayloadWithDataHash method in ServerActionExecutionCapabilityDelegate

## 4.2.1

- Added new methods to DuitDataSource extension

## 4.2.0-rc.3

- Public API deprecation

## 4.2.0-rc.2

- New capability-base UIDriver API + docs

## 4.2.0-rc.1

- New capability-base UIDriver API

## 4.1.0

- FocusNode and related types are supported in DuitDataSource
- Focus node management AP

## 4.0.1

- Patch for DuitDataSource: better Tween models handling, custom Curve parsing from json

## 4.0.0

- Updated remote command API
- Added DuitDataSource - extension type for work with JSON as string-typed objects
- Flutter/Dart types to JSON encoder
- Attribute object warm up function
- Package API cleanup
- Added debounce and throttle for action exec configuration
- Improve performance

## 3.3.2

- Added component registry

## 3.3.1

- Themes patch

## 3.3.0

- Added experimental theme support

## 3.2.0

- New stream of typed events from driver
- Duit view abstraction
- View display state changes handling

## 3.1.0

- Added DebugLogger interface and default implementation for it
- Extend UIDriver API
- Extend UIElementController API
- Models of actions and events and some models for animations have been moved to the kernel

## 3.0.0

- Rename: DuitScript -> ScriptDefinition
- Rename: DuitAbstractTree -> ElementTree
- Rename: TreeElement -> ElementTreeEntry
- Rename: DuitComponentDescription -> ComponentDescription
- Rename: DuitScriptRunner -> ScriptRunner
- UIElementController attributes property no longer nullable (ViewAttributes?)
- Added `detach` method to UIElementController
- Bump minimal version of dart sdk to 3.4.4
- Removed concurrency related models and methods
- Component registration API is now asynchronous

## 2.1.3

- Added `subviews` parameter to ModelFactory and BuildFactory signatures

## 2.1.1

- Fixed a problem with passing the ID parameter to the attribute parser

## 2.1.0

- Implemented preliminary preparation of component layouts

## 2.0.1

- Fixed a bug with generic factory types

## 2.0.0

- Transport API was been modified. Transport.connect method can receive initial request data
  parameter.
- Modified project structure
- Rename some structures: ModelMapper => ModelFactory, AttributesMapper => AttributesFactory,
  Renderer => BuildFactory, ViewAttributesWrapper => ViewAttribute;
- Added AnimatedPropertyOwner class for describe animations
- Removed unused extensions and dead-code

## 1.4.1

- Added id property for attribute objects

## 1.4.0

- New methods for driver, controller and tree models

## 1.3.0

- Added experimental concurrent mode

## 1.2.3

- Removed ref paths extraction

## 1.2.2

- Updated DuitComponentDescription model. Added a property containing paths to refs properties in
  objects containing them. Added function for extracting paths from json

## 1.2.1

- Added meta property to script model

## 1.2.0

- Added base classes for scripting implementation

## 1.1.1

- The ServerAction model has been extended with new properties to maintain local executed actions

## 1.1.0

- Added classes for implementing Duit components, such as DuitComponentDescription and
  ValueReference

## 1.0.1

- fix: code formation

## 1.0.0

- The release contains the main models on the basis of which the implementation of the flutter_duit
  library is built. Models are also used for developing third-party extensions.
