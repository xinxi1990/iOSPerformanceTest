platform :ios, '9.0'
inhibit_all_warnings!

workspace 'SocketDemo.xcworkspace'

target "UICatalog" do
  
  xcodeproj 'UICatalog.xcodeproj'
  pod 'YYKit'
  pod 'Aspects'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts "#{target.name}"
  end
end
