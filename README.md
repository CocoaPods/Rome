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
