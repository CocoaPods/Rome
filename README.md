# cocoapods-rome

![](yolo.jpg)

Rome makes it easy to build a list of frameworks for consumption outside of
Xcode, e.g. for a Swift script.

## Installation

```bash
$ gem install cocoapods-rome
```

## Usage

Write a simple Podfile like this:

```ruby
platform :osx, '10.10'

plugin 'cocoapods-rome'

target 'caesar' do
  pod 'Alamofire'
end
```

then run this:

```bash
pod install
```

and you will end up with dynamic frameworks:

```
$ tree Rome/
Rome/
└── Alamofire.framework
```

For your production builds, when you want dSYMs created and stored:

```ruby
platform :osx, '10.10'

plugin 'cocoapods-rome', {
  dsym: true,
  configuration: 'Release'
}

target 'caesar' do
  pod 'Alamofire'
end
```

Resulting in:

```
$ tree dSYM/
dSYM/
├── iphoneos
│   └── Alamofire.framework.dSYM
│       └── Contents
│           ├── Info.plist
│           └── Resources
│               └── DWARF
│                   └── Alamofire
└── iphonesimulator
    └── Alamofire.framework.dSYM
        └── Contents
            ├── Info.plist
            └── Resources
                └── DWARF
                    └── Alamofire
```

## Hooks

The plugin allows you to provides hooks that will be called during the installation process.

### `pre_compile`

This hook allows you to make any last changes to the generated Xcode project before the compilation of frameworks begins.

It receives the `Pod::Installer` as its only argument.

#### Example

Customising the Swift version of all pods

```ruby
platform :osx, '10.10'

plugin 'cocoapods-rome', :pre_compile => Proc.new { |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end

    installer.pods_project.save
}

target 'caesar' do
    pod 'Alamofire'
end
```
