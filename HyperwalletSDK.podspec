Pod::Spec.new do |spec|
    spec.name                  = 'HyperwalletSDK'
    spec.version               = '1.0.0-beta02'
    spec.summary               = 'Hyperwallet Core SDK for iOS to integrate with Hyperwallet Platform'
    spec.homepage              = 'https://github.com/hyperwallet/hyperwallet-ios-sdk'
    spec.license               = { :type => 'MIT', :file => 'LICENSE' }
    spec.author                = { 'Hyperwallet Systems Inc' => 'devsupport@hyperwallet.com' }
    spec.platform              = :ios
    spec.ios.deployment_target = '10.0'
    spec.source                = { :git => 'https://github.com/hyperwallet/hyperwallet-ios-sdk.git', :tag => "#{spec.version}" }
    spec.source_files          = 'Sources/**/*.swift'
    spec.requires_arc          = true
    spec.swift_version         = '4.2'

    spec.test_spec 'Tests' do |test_spec|
        test_spec.source_files = 'Tests/**/*.swift'
        test_spec.resources = 'Tests/**/*.json'
        test_spec.dependency 'Hippolyte'
    end
end
